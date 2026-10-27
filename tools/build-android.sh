#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../apps/client"
mode="${1:-debug}"
case "$mode" in
  debug) flutter pub get; flutter build apk --debug ;;
  release|bundle)
    if [[ ! -f android/key.properties ]]; then
      printf 'Configure android/key.properties com sua chave de assinatura antes do build distribuível.\n' >&2
      exit 1
    fi
    flutter pub get
    if [[ "$mode" == bundle ]]; then flutter build appbundle --release; else flutter build apk --release; fi
    ;;
  *) printf 'Uso: tools/build-android.sh [debug|release|bundle]\n' >&2; exit 1 ;;
esac
