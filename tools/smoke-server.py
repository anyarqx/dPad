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
with tempfile.TemporaryDirectory(prefix='dpad-smoke-') as workspace:
    data = str(Path(workspace) / 'installation')
    def launch(test=False):
        instance = str(uuid.uuid4())
        command = [str(binary), '--data', data, '--host', '127.0.0.1', '--port', str(port),
                   '--controlled', '--instance', instance, '--web', str(root / 'apps/client/build/web')]
        if test:
            command.append('--test')
        p = subprocess.Popen(command, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
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
    def api(path, body=None, profile=None):
        headers = {'Content-Type': 'application/json'}
        if profile:
            headers['X-Profile'] = profile
        elif token:
            headers['Authorization'] = 'Bearer ' + token
        req = urllib.request.Request(origin + '/api/v1/' + path, data=None if body is None else json.dumps(body).encode(), headers=headers)
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

    maintenance = launch()
    try:
        backup = api('maintenance/backups', {})
        headers = {'Authorization': 'Bearer ' + token}
        content = 'maintenance/backups/' + backup['id'] + '/content'
        with urllib.request.urlopen(urllib.request.Request(origin + '/api/v1/' + content, headers=headers)) as response:
            archive = response.read()
        upload = urllib.request.Request(origin + '/api/v1/maintenance/inspect', data=archive,
                                        headers={**headers, 'Content-Type': 'application/zip'})
        with urllib.request.urlopen(upload) as response:
            inspection = json.load(response)
        assert inspection['backup']['counts']['documents'] == 1
        api('students', {'name': 'Cadastro temporário para restaurar'})
        assert api('maintenance/restore/' + inspection['id'], {'confirmation': 'RESTAURAR'})['restored']
        login = api('auth/login', {'login': 'administrador', 'password': 'senha longa do smoke teste'})
        token = login['token']
        assert [row['id'] for row in api('students')] == [person['id']]
        assert len(api('maintenance/backups')) == 2
    finally:
        stop(maintenance)

    production_database = Path(data) / 'database.sqlite'
    before_test = production_database.read_bytes()
    test = launch(test=True)
    try:
        state = api('bootstrap', profile='admin')
        assert state['session']['test']
        assert len(state['classes']) == 2
        assert len(api('students', profile='responsavel')) == 1
        account = api('accounts', {
            'name': 'Operador fictício',
            'login': 'operador.teste',
            'password': 'senha escolhida para esta execução',
            'role': 'secretaria',
        }, profile='admin')
    finally:
        stop(test)
    test = launch(test=True)
    try:
        assert any(row['id'] == account['id'] for row in api('accounts', profile='admin'))
        assert api('reset', {'confirmation': 'RESTAURAR'}, profile='admin')['restored']
        assert all(row['id'] != account['id'] for row in api('accounts', profile='admin'))
        assert len(api('classes', profile='admin')) == 2
    finally:
        stop(test)
    assert production_database.read_bytes() == before_test
    print('OK: backup, restauração com cópia de recuperação, instância de testes isolada e contas persistidas após reinício.')
