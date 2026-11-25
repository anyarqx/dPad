#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
root=$PWD
case "$(uname -m)" in
  x86_64) arch=x64;;
  aarch64|arm64) arch=arm64;;
  *) echo 'Arquitetura Linux não suportada' >&2; exit 1;;
esac
[[ "${1:-$arch}" == "$arch" ]] || { echo 'Use um host da arquitetura solicitada' >&2; exit 1; }
(cd apps/server && dart pub get && dart build cli --target bin/dPad_server.dart -o build/server)
(cd apps/client && flutter pub get && flutter build linux --release)
bundle="$root/apps/client/build/linux/$arch/release/bundle"
test -x "$bundle/papel_digital"
rm -rf "$bundle/server"
mkdir -p "$bundle/server" "$root/dist"
cp -a apps/server/build/server/bundle/. "$bundle/server/"
test -x "$bundle/server/bin/dPad_server"
tar -czf "$root/dist/DoPapelAoDigital-linux-$arch.tar.gz" -C "$bundle" .
printf 'Bundle: %s\n' "$root/dist/DoPapelAoDigital-linux-$arch.tar.gz"
