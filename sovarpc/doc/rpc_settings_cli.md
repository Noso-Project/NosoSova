# SovaRPC-CLI Configuration Manual
SovaRPC has a version for use as a cli on headless servers. To get the sovarpc-cli, you can compile it yourself or download it from the releases page.

## The main things you need to know 
- sovarpc-cli is not a part of NosoSova, SovaRPC-GUI, it works with separate files and its own database.
- the configuration file is created by a special command in the folder with the executable.
- rpc and wallet are not synchronised with each other, what does this mean? they use a common database, but when they start, the applications copy their own copy for themselves... so if you start rpc and then import addresses through wallet, they will not be available to rpc until you restart.

## Build

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Dart SDK](https://dart.dev/get-dart)
- IDE (e.g., [Visual Studio Code](https://code.visualstudio.com/) with Flutter/Dart extension)

Follow the instructions in this guide [Installation Flutter](https://docs.flutter.dev/get-started/install/windows)

To build, use the following commands:

```bash
git clone https://github.com/Noso-Project/NosoSova.git
cd NosoSova
## Macos only
cd macos && pod install
cd ..
#######################
flutter pub get
cd sovarpc
## Macos only
cd macos && pod install
cd ..
#######################
flutter pub get
cd bin
dart compile exe wallet.dart -o wallet
dart compile exe rpc.dart -o rpc
```


After running these commands, you will get two executable files **rpc** && **wallet**.

## CLI commands 

## Example of configuration

## RPC Work Backups

When using the commands `getnewaddress` and `getnewaddressfull`, generated addresses are added to the database and duplicated in a file located at:

> APP_FOLDER/nososova/backups/backup_addresses.json

## Checking RPC Operation and Restart

To check the status of **RPC**, you can use a **GET** request on the route **rpc:port/health-check**. Monitor the **sync** status; if it is **false**, there may be a failure or a local network freeze (a common feature of the noso network). To reconnect, you can use the RPC [restart method](https://github.com/Noso-Project/NosoSova/blob/v0.4.6/sovarpc/doc/rpc_methods.md#restart).
