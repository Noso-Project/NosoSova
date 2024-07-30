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
     cd macos && pod install && cd ..
     flutter clean
     flutter build macos
     rm -R -f "$FPRODUCTION"
     mkdir "$FPRODUCTION"
     mkdir "$FPRODUCTION/$FSOVA"
     cp -r build/macos/Build/Products/Release/NosoSova.app "$FPRODUCTION/$FSOVA"

}

check_dart_flutter
build_linux_sova
