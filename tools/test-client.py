"""Executa flutter test com preferências Linux reais isoladas em diretório temporário."""
import os
from pathlib import Path
import subprocess
import sys
import tempfile

root = Path(__file__).resolve().parent.parent
with tempfile.TemporaryDirectory(prefix='dpad-client-preferences-') as directory:
    env = dict(os.environ, DPAD_UI_TESTS='1',
               XDG_DATA_HOME=str(Path(directory) / 'data'),
               XDG_CONFIG_HOME=str(Path(directory) / 'config'))
    result = subprocess.run(['flutter', 'test', '--concurrency=1', *sys.argv[1:]],
                            cwd=root / 'apps/client', env=env)
    raise SystemExit(result.returncode)
