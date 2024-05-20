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
     flutter clean
     flutter build linux
     rm -R -f "$FPRODUCTION"
     mkdir "$FPRODUCTION"
     cp -r build/linux/x64/release/bundle "$FPRODUCTION"
     cd "$FPRODUCTION" && mv bundle $FSOVA

}

build_linux_rpc() {
     cd ..
     cd sovarpc
     flutter clean
     flutter build linux
     cd ..
     cp -r sovarpc/build/linux/x64/release/bundle "$FPRODUCTION"
     cd "$FPRODUCTION" && mv bundle $FRPC

}
build_linux_cli() {
     cd ..
     cd sovarpc
     cd bin
     dart compile exe wallet.dart -o wallet
     dart compile exe rpc.dart -o rpc
     cd ../../
     mkdir "$FPRODUCTION/$FRPCCLI"
     cp sovarpc/bin/wallet "$FPRODUCTION/$FRPCCLI"
     cp sovarpc/bin/rpc "$FPRODUCTION/$FRPCCLI"

}
check_dart_flutter
build_linux_sova
build_linux_rpc
build_linux_cli

