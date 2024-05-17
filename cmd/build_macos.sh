#!/bin/bash
FSOVA="NosoSova"
FRPC="sovarpc-gui"
FRPCCLI="sovarpc-cli"
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

build_linux_rpc() {
     cd sovarpc
     cd macos && pod install && cd ..
     flutter clean
     flutter build macos
     cd ..
     mkdir "$FPRODUCTION/$FRPC"
     cp -r sovarpc/build/macos/Build/Products/Release/sovarpc.app "$FPRODUCTION/$FRPC"

}

build_linux_cli() {
     cd sovarpc
     cd bin
     dart compile exe wallet.dart -o wallet
     dart compile exe rpc.dart -o rpc
     cd ../../ ##.//
     mkdir "$FPRODUCTION/$FRPCCLI"
     cp sovarpc/bin/wallet "$FPRODUCTION/$FRPCCLI"
     cp sovarpc/bin/rpc "$FPRODUCTION/$FRPCCLI"

}

check_dart_flutter
build_linux_sova
build_linux_rpc
build_linux_cli
