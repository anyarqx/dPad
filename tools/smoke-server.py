"""Verifica instalação vazia, pasta de aluno, PDF, Web e persistência reais."""
import json
from datetime import date
from pathlib import Path
import socket
import subprocess
import tempfile
import time
import urllib.parse
import urllib.request
import uuid

root = Path(__file__).resolve().parent.parent
binary = root / 'apps/server/build/server/bundle/bin/dPad_server'
with socket.socket() as reservation:
    reservation.bind(('127.0.0.1', 0))
    port = reservation.getsockname()[1]
origin = f'http://127.0.0.1:{port}'
token = None
with tempfile.TemporaryDirectory(prefix='dpad-smoke-') as data:
    def launch():
        instance = str(uuid.uuid4())
        p = subprocess.Popen([str(binary), '--data', data, '--port', str(port), '--controlled', '--instance', instance, '--web', str(root / 'apps/client/build/web')], stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        for _ in range(100):
            if p.poll() is not None:
                raise RuntimeError(p.stderr.read())
            try:
                with urllib.request.urlopen(origin + '/health', timeout=1) as r:
                    health = json.load(r)
                    if health.get('instance') == instance and health['status'] == 'ok':
                        return p
            except OSError:
                pass
            time.sleep(.1)
        p.terminate()
        p.wait(timeout=10)
        raise RuntimeError('Servidor não iniciou')
    def api(path, body=None):
        req = urllib.request.Request(origin + '/api/v1/' + path, data=None if body is None else json.dumps(body).encode(), headers={'Content-Type': 'application/json', **({'Authorization': 'Bearer ' + token} if token else {})})
        with urllib.request.urlopen(req, timeout=30) as r:
            return json.load(r)
    def stop(p):
        p.communicate('shutdown\n', timeout=10)
        assert p.returncode == 0
    first = launch()
    try:
        assert api('auth/status')['setupRequired']
        session = api('auth/setup', {'name': 'Administrador do teste', 'login': 'administrador', 'password': 'senha longa do smoke teste'})
        token = session['token']
        for resource in ['students', 'folders', 'documents', 'requests', 'courses', 'classes', 'templates']:
            assert api(resource) == []
        with urllib.request.urlopen(origin + '/') as r:
            assert b'flutter_bootstrap.js' in r.read()
        with urllib.request.urlopen(origin + '/students') as r:
            assert b'flutter_bootstrap.js' in r.read()
        model = json.loads((root / 'assets/templates/pasta-escolar.json').read_text())
        template = api('templates', model)
        course = api('courses', {'name': 'Formacao do teste', 'modality': 'Modalidade de teste', 'template': template['id']})
        group = api('classes', {'course': course['id'], 'name': 'Turma de teste', 'school_year': date.today().year, 'period_label': 'Anual', 'grade': 'Etapa de teste', 'shift': 'Matutino', 'capacity': 20})
        person = api('students', {'name': 'Aluno do teste de execucao', 'registration': 'SMOKE-01', 'class_group': group['id']})
        assert len(person['requirements']) == len(model['documents'])
        request = api('requests', {'operation': 'smoke-request', 'student': person['id'], 'service': 'requerimento', 'subject': 'Teste do requerimento', 'description': 'Registro temporario para verificar a geracao e o armazenamento.'})
        with urllib.request.urlopen(urllib.request.Request(origin + '/api/v1/requests/' + request['id'] + '/pdf', data=b'', headers={'Authorization': 'Bearer ' + token})) as r:
            pdf = r.read()
            assert pdf.startswith(b'%PDF')
        boundary = 'dpad-' + uuid.uuid4().hex
        multipart = (f'--{boundary}\r\nContent-Disposition: form-data; name="file"; filename="requerimento.pdf"\r\nContent-Type: application/pdf\r\n\r\n').encode() + pdf + f'\r\n--{boundary}--\r\n'.encode()
        query = urllib.parse.urlencode({'folder': person['folder'], 'name': 'requerimento.pdf', 'type': 'Requerimento'})
        with urllib.request.urlopen(urllib.request.Request(origin + '/api/v1/documents?' + query, data=multipart, headers={'Authorization': 'Bearer ' + token, 'Content-Type': f'multipart/form-data; boundary={boundary}'})) as r:
            document = json.load(r)
        duplicate = subprocess.run([str(binary), '--data', data, '--port', '0'], capture_output=True, text=True, timeout=10)
        assert duplicate.returncode != 0 and 'Outra instância' in duplicate.stderr
    finally:
        stop(first)
    second = launch()
    try:
        assert not api('auth/status')['setupRequired']
        assert api('classes')[0]['id'] == group['id']
        assert api('students/' + person['id'] + '/enrollments')['items'][0]['class_group'] == group['id']
        assert api('students')[0]['id'] == person['id']
        assert api('students/' + person['id'])['documents'][0]['id'] == document['id']
        with urllib.request.urlopen(urllib.request.Request(origin + '/api/v1/documents/' + document['id'] + '/content', headers={'Authorization': 'Bearer ' + token})) as r:
            assert r.read() == pdf
    finally:
        stop(second)
    # EOF no canal de controle também encerra o backend se o cliente hospedeiro morrer.
    orphan_check = launch()
    orphan_check.stdin.close()
    orphan_check.wait(timeout=10)
    assert orphan_check.returncode == 0
    print('OK: instalação vazia, login, modelo, curso, turma, matrícula, PDF real, Web, trava de instância, encerramento por EOF e persistência após reinício.')
