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
| --import| -i    | <wallet.pkw>       | Import your addresses from a .pkw file, use the <file_name.pkw> parameter. Before using, place the file in the same folder as the wallet executable file |
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

To use it in linux, you need to install the libsqlite3 library and grant execution rights

```bash
apt-get install sqlite3 libsqlite3-dev
chmod +x wallet && chmod +x rpc
```

Next steps:

```bash
## Create config && set config
./rpc --config

## Set your public ip and open port on which you plan to broadcast RPC
nano rpc_config.yaml

## Import addresses (Before doing this, place the wallet file in the wallet folder, after importing it, you no longer need it)
./wallet --import walletName.pkw

## Set payment (default) address
./wallet --setPaymentAddress hashAddress

## Check if your data matches
./wallet --wallet

## Run RPC
./rpc (./rpc --run)
```

### Run rpc for systemd

To run the cli app continuously on a system. It is recommended to add it to a service manager like systemd.
Here is a minimal viable example on how to do that.

1. Add a service

```bash
sudo nano /etc/systemd/system/sova_rpc.service
```

2. Adjust file content

```bash
Description=Noso Sova RPC

[Service]
ExecStart=/path/to/file/rpc -r
Restart=on-abnormal
WorkingDirectory=/path/to/working/dir
User=your_user

[Install]
WantedBy=multi-user.target 
```

3. Enable service

```bash
sudo systemctl enable sova_rpc.service
```

4. Start service

```bash
sudo systemctl start sova_rpc.service
```

5. (Optional) check status

```bash
sudo systemctl status sova_rpc.service
```

## RPC Work Backups

When using the commands `getnewaddress` and `getnewaddressfull`, generated addresses are added to the database and duplicated in a file located at:

> sovarpc/backups/backup_addresses.json

## Checking RPC Operation and Restart

To check the status of **RPC**, you can use a **GET** request on the route **rpc:port/health-check**. Monitor the **sync** status; if it is **false**, there may be a failure or a local network freeze (a common feature of the noso network). To reconnect, you can use the RPC [restart method](https://github.com/Noso-Project/NosoSova/blob/v0.4.6/sovarpc/doc/rpc_methods.md#restart).
