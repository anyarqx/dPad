"""Gera ícones nativos a partir de assets/logo.svg (requer rsvg-convert e Pillow)."""
from pathlib import Path
import subprocess
import shutil
import xml.etree.ElementTree as ET
from PIL import Image

root = Path(__file__).resolve().parent.parent
namespace = 'http://www.w3.org/2000/svg'
ET.register_namespace('', namespace)
source = root / 'assets/logo.svg'
shutil.copyfile(source, root / 'apps/client/assets/logo.svg')

def render(path, size, *, foreground=False, opaque=False):
    canvas = ET.Element(f'{{{namespace}}}svg', {'viewBox': '0 0 108 108', 'width': '108', 'height': '108'})
    if not foreground or opaque:
        ET.SubElement(canvas, f'{{{namespace}}}rect', {'width': '108', 'height': '108', 'rx': '18', 'fill': '#ffffff'})
    logo = ET.parse(source).getroot()
    inset = 22 if foreground else 14
    logo.attrib.update(x=str(inset), y=str(inset), width=str(108-2*inset), height=str(108-2*inset))
    canvas.append(logo)
    path.parent.mkdir(parents=True, exist_ok=True)
    subprocess.run(['rsvg-convert', '-w', str(size), '-h', str(size), '-o', str(path)], input=ET.tostring(canvas), check=True)

resources = root / 'apps/client/android/app/src/main/res'
for density, scale in [('mdpi', 1), ('hdpi', 1.5), ('xhdpi', 2), ('xxhdpi', 3), ('xxxhdpi', 4)]:
    render(resources / f'mipmap-{density}/ic_launcher.png', int(48*scale))
    render(resources / f'mipmap-{density}/ic_launcher_foreground.png', int(108*scale), foreground=True)
adaptive = resources / 'mipmap-anydpi-v26/ic_launcher.xml'
adaptive.parent.mkdir(parents=True, exist_ok=True)
adaptive.write_text('<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android"><background android:drawable="@android:color/white"/><foreground android:drawable="@mipmap/ic_launcher_foreground"/></adaptive-icon>\n')
for name in ['Icon-192', 'Icon-512', 'Icon-maskable-192', 'Icon-maskable-512']:
    render(root / f'apps/client/web/icons/{name}.png', int(name.split('-')[-1]), foreground='maskable' in name, opaque=True)
render(root / 'apps/client/web/favicon.png', 32)
render(root / 'apps/client/assets/app-icon.png', 256)
with Image.open(root / 'apps/client/assets/app-icon.png') as image:
    image.save(root / 'apps/client/windows/runner/resources/app_icon.ico', sizes=[(16,16),(24,24),(32,32),(48,48),(64,64),(128,128),(256,256)])
print('Ícones Android, Web e Windows gerados a partir da logo SVG.')
