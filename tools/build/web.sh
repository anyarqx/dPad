#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../../apps/client"
flutter pub get
flutter build web --release --no-web-resources-cdn
mkdir -p ../../dist
archive="$PWD/../../dist/DoPapelAoDigital-web.zip"
rm -f "$archive"
(cd build/web && zip -qr "$archive" .)
