#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
(cd apps/server && dart pub get && dart build cli --target bin/dPad_server.dart -o build/server)
(cd apps/client && flutter pub get && flutter build linux --release)
mkdir -p apps/client/build/linux/x64/release/bundle/server
cp -R apps/server/build/server/bundle/. apps/client/build/linux/x64/release/bundle/server/
printf 'Aplicativo: apps/client/build/linux/x64/release/bundle/papel_digital\n'
