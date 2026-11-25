#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../../apps/client"
arch=${1:-arm64}
mode=${2:-release}
case "$arch" in
  armv7) target=android-arm;;
  arm64) target=android-arm64;;
  x64) target=android-x64;;
  *) echo 'Uso: android.sh [armv7|arm64|x64] [debug|release]' >&2; exit 1;;
esac
case "$mode" in
  release) test -f android/key.properties || { echo 'Configure android/key.properties' >&2; exit 1; };;
  debug) ;;
  *) exit 1;;
esac
flutter pub get
flutter build apk "--$mode" --target-platform "$target"
mkdir -p ../../dist
suffix=''; [[ "$mode" != debug ]] || suffix=-debug
cp "build/app/outputs/flutter-apk/app-$mode.apk" "../../dist/DoPapelAoDigital-android-$arch$suffix.apk"
