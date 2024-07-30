#!/bin/bash
FSOVA="NosoSova"
FPRODUCTION="Release"

check_dart_flutter() {
    if ! command -v dart &> /dev/null || ! command -v flutter &> /dev/null; then
        echo "Dart or Flutter is not installed."
        exit 1
    fi
}

build_linux_sova() {
     cd ..
     flutter clean
     flutter build linux
     rm -R -f "$FPRODUCTION"
     mkdir "$FPRODUCTION"
     cp -r build/linux/x64/release/bundle "$FPRODUCTION"
     cd "$FPRODUCTION" && mv bundle $FSOVA

}

check_dart_flutter
build_linux_sova

