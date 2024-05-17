# SovaRPC-CLI Configuration Manual

**SovaRPC** has a version for use as a cli on headless servers. To get the **sovarpc-cli**, you can compile it yourself or download it from the [releases page](https://github.com/Noso-Project/NosoSova/releases).

## The main things you need to know

- **sovarpc-cli** is not a part of **NosoSova**, **SovaRPC-GUI**, it works with separate files and its own database.
- the configuration file is created by a special command in the folder with the executable.
- **rpc** and **wallet** are not synchronised with each other, what does this mean? they use a common database, but when they start, the applications copy their own copy for themselves... so if you start **rpc** and then import addresses through **wallet**, they will not be available to **rpc** until you restart.

## Build

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Dart SDK](https://dart.dev/get-dart)
- IDE (e.g., [Visual Studio Code](https://code.visualstudio.com/) with Flutter/Dart extension)
- For macos you must install [COCOAPODS](https://cocoapods.org/) && [Homebrew](https://brew.sh/)

Follow the instructions in this guide [Installation Flutter](https://docs.flutter.dev/get-started/install/windows)

### Process
To build, use the following commands, or use the script that is located in the **NosoSova/cmd** path, it will save the results in the **Release** folder

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
### RPC
| Command    | Short | Parameter | Description                                                                          |
|------------|-------|-----------|--------------------------------------------------------------------------------------|
| --help     | -h    |           | Show all RPC commands                                                                |
| --methods  | -m    |           | Show all JSON-RPC methods                                                            |
| --run      | -r    |           | Start RPC mode                                                                       |
| --config   | -c    |           | Displays the contents of the configuration file, if it does not exist, it creates it. |


### Wallet
| Command | Short | Parameter          | Description                                                                                                  |
|---------|-------|--------------------|--------------------------------------------------------------------------------------------------------------|
| --help  | -h    |                    | Show all wallet commands                                                                                     |
| --import| -i    | <wallet.pkw>       | Import your addresses from a .pkw file, use the <file_name.pkw> parameter. Before using, place the file in the same folder as the wallet.exe executable file |
| --export| -e    |                    | Export your addresses in .pkw file                                                                           |
| --wallet| -w    |                    | Returns information about the wallet                                                                         |
| --addresses| -a |                    | Returns list of all addresses                                                                                |
| --fullAddresses| -f |                | Returns a list of all addresses with a key pair in JSON format                                               |
| --new  | -n    | <--no-save>        | Create a new address, can be used with the --no-save flag then this address will not be saved locally        |
| --no-save|       |                   | Disables saving address for local database                                                                   |
| --isLocal| -l   | <hash>             | Checks if the address is saved locally, use <hash> parameter                                                 |
| --setPaymentAddress| -p | <hash>     | Sets the default payment address use <hash> parameter                                                        |


## Example of configuration

This example demonstrates how to install and configure the release on your server



## RPC Work Backups

When using the commands `getnewaddress` and `getnewaddressfull`, generated addresses are added to the database and duplicated in a file located at:

> sovarpc/backups/backup_addresses.json

## Checking RPC Operation and Restart

To check the status of **RPC**, you can use a **GET** request on the route **rpc:port/health-check**. Monitor the **sync** status; if it is **false**, there may be a failure or a local network freeze (a common feature of the noso network). To reconnect, you can use the RPC [restart method](https://github.com/Noso-Project/NosoSova/blob/v0.4.6/sovarpc/doc/rpc_methods.md#restart).
