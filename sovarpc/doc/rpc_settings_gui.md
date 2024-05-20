# SovaRPC Configuration Manual

**SovaRPC** is an **RPC** emulation based on node operation cloning and [REST API](https://api.nosocoin.com/docs/) support.

This utility shares a common working directory and database with NosoSova, but they do not interact with each other in any way.

**Important:** **NosoSova** and **SovaRPC** do not exchange information. They also do not interact synchronously with the database. Thus, if you open **RPC** and later import your wallet into **NosoSova**, it will not appear in SovaRPC until the next restart.

### Paths to the SovaRPC Working Folder (APP_FOLDER)

```text
Windows:
\Users\UserName\AppData\Roaming\NosoCoin
```

```text
Ubuntu:
/home/pasichDev/.local/share/com.pasivhdev.nososova.nososova
```

## Steps to Launch and Configure:

1. Start the node and configure it.
2. Launch SovaRPC.
3. Enter the necessary data, such as public IP and port.
4. Activate the RPC Enable toggle switch; you will see a log entry indicating the launch of RPC.

## Wallet Import and Export

Under the settings, there are two buttons for importing and exporting the wallet. These will only be active when RPC is turned off.

## RPC Work Backups

When using the commands `getnewaddress` and `getnewaddressfull`, generated addresses are added to the database and duplicated in a file located at:

> APP_FOLDER/nososova/backups/backup_addresses.json

## Checking RPC Operation and Restart

To check the status of **RPC**, you can use a **GET** request on the route **rpc:port/health-check**. Monitor the **sync** status; if it is **false**, there may be a failure or a local network freeze (a common feature of the noso network). To reconnect, you can use the RPC [restart method](https://github.com/Noso-Project/NosoSova/blob/v0.4.6/sovarpc/doc/rpc_methods.md#restart).
