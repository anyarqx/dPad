"""Atualiza o catálogo local de municípios e UFs a partir da API pública do IBGE."""
import json
import gzip
from datetime import datetime, timezone
from pathlib import Path
from urllib.request import urlopen

BASE = 'https://servicodados.ibge.gov.br/api/v1/localidades'
def fetch(resource):
    with urlopen(BASE + resource, timeout=60) as response:
        data=response.read()
        if data[:2]==b'\x1f\x8b': data=gzip.decompress(data)
        return json.loads(data)

states = fetch('/estados?orderBy=nome')
cities = fetch('/municipios?orderBy=nome')
rows = []
for city in cities:
    immediate = city.get('regiao-imediata') or {}
    intermediate = immediate.get('regiao-intermediaria') or {}
    uf = intermediate.get('UF')
    if not uf:
        micro = city.get('microrregiao') or {}
        uf = (micro.get('mesorregiao') or {}).get('UF')
    if not uf:
        raise ValueError('Município sem UF: ' + city['nome'])
    rows.append([city['id'], city['nome'], uf['sigla']])
assert len(states) == 27 and len(rows) >= 5570
assert len({row[0] for row in rows}) == len(rows)
output = Path(__file__).resolve().parent.parent / 'apps/client/assets/data/br-localities.json'
output.write_text(json.dumps({
    'source': BASE, 'retrieved_at': datetime.now(timezone.utc).isoformat(),
    'states': [[s['id'], s['nome'], s['sigla']] for s in states],
    'cities': rows,
}, ensure_ascii=False, separators=(',', ':')) + '\n')
print(f'Catálogo IBGE: {len(states)} UFs, {len(rows)} municípios; {output.stat().st_size} bytes.')
