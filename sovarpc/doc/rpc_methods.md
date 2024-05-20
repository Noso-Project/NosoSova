# Manual for interaction with RPC

### List of commands that are provided

- getmainnetinfo (getNetworkInfo) ✅
- getpendingorders ✅
- getblockorders ✅
- getorderinfo ✅
- getaddressbalance ✅
- getnewaddress ✅
- getnewaddressfull ✅
- islocaladdress ✅
- getwalletbalance ✅
- setdefault ✅
- sendfunds (transfer) ✅
- reset ✅

# health-check

This method returns the status of rpc synchronization by the noso and rest api.

### Example REST-API call

```javascript
{
    http://202.10.***.**:8078/health-check
}
```

### Example REST-API result

```json
{
  "REST-API": {
    "API": "running",
    "nosoDB": "synced"
  },
  "Noso-Network": {
    "seed": "141.145.194.9:8080",
    "block": 160718,
    "utc_time": 1714674356,
    "node_version": "0.4.2Cb1",
    "sync": true
  }
}
```

# getmainnetinfo (getNetworkInfo)

This method returns information from the noso network

> **Returns:** lastblock, lastblockhash, headershash, summaryhash, pending, supply.

### Example JSON-RPC call

```json
{
  "jsonrpc": "2.0",
  "method": "getmainnetinfo",
  "params": [],
  "id": 15
}
```

### Example JSON-RPC result

```json
{
  "jsonrpc": "2.0",
  "result": [
    {
      "lastblock": 160717,
      "lastblockhash": "25BAE",
      "headershash": "300",
      "sumaryhash": "98969",
      "pending": 0,
      "supply": 804615390730000
    }
  ],
  "id": 15
}
```

### Example JSON-RPC error

```json
{
  "jsonrpc": "2.0",
  "result": [
    {
      "lastblock": 0,
      "lastblockhash": "",
      "headershash": "",
      "sumaryhash": "",
      "pending": 0,
      "supply": 0
    }
  ],
  "id": 15
}
```

# getpendingorders

This method returns the transactions that are pending

### Example JSON-RPC call

```json
{
  "jsonrpc": "2.0",
  "method": "getpendingorders",
  "params": [],
  "id": 15
}
```

### Example JSON-RPC result

```json
{
  "jsonrpc": "2.0",
  "result": [
    {
      "pendings": [
        "OR41rixbb4q0gqiytcxdxndx3euvsgzuff0v1y8iog6i0nu90g8c,
        1714674694,TRFR,N4ZR3fKhTUod34evnEcDQX3i6XufBDU,
        N2bXDNq8mogt75naxi6uamrjvWn7ZGe,1000000000,1000000,"
      ]
    }
  ],
  "id": 15
}
```

### Empty

```json
{ "jsonrpc": "2.0", "pendings": [], "id": 15 }
```

# getblockorders

this method returns transactions that occurred in a specific block

### Example JSON-RPC call

```json
{
  "jsonrpc": "2.0",
  "method": "getblockorders",
  "params": ["121706"],
  "id": 15
}
```

### Example JSON-RPC result

```json
{
  "jsonrpc": "2.0",
  "result": [
    {
      "valid": true,
      "block": 159560,
      "orders": [
        {
          "orderid": "1tRCvuxKj7YEMy7xMxcVMqYxVQebRQUtAEXqiLufxRFbYMNRF",
          "timestamp": 1713979199,
          "block": 159560,
          "type": "PROJCT",
          "trfrs": 1,
          "receiver": "NpryectdevepmentfundsGE",
          "amount": 500200000,
          "fee": 0,
          "reference": "null",
          "sender": "COINBASE"
        }
      ]
    }
  ],
  "id": 15
}
```

### Example JSON-RPC error

```json
{
  "jsonrpc": "2.0",
  "result": [
    {
      "valid": false,
      "block": -1,
      "orders": []
    }
  ],
  "id": 15
}
```

# getorderinfo

This method displays information about the transaction

### Example JSON-RPC call

```json
{
  "jsonrpc": "2.0",
  "method": "getorderinfo",
  "params": ["OR2upgmg8vqs1ypx3uk4k51xxbm27c94peib7w0t7hgvf2wj8djw"],
  "id": 15
}
```

### Example JSON-RPC result

```json
{
  "jsonrpc": "2.0",
  "result": [
    {
      "valid": true,
      "order": {
        "orderid": "OR2upgmg8vqs1ypx3uk4k51xxbm27c94peib7w0t7hgvf2wj8djw",
        "timestamp": 1691264501,
        "block": 121886,
        "type": "TRFR",
        "trfrs": 1,
        "receiver": "N4Eq5xfuhsMtLBGsz8VM5j1mLQwrwFz",
        "amount": 100000000,
        "fee": 1000000,
        "reference": "Example-Reference",
        "sender": "N2jBDcbxDUuj2tdJ61pLXPj5zqPxbF1"
      }
    }
  ],
  "id": 15
}
```

### Example JSON-RPC error

```json
{
  "jsonrpc": "2.0",
  "result": [
    {
      "valid": false,
      "order": null
    }
  ],
  "id": 15
}
```

# getaddressbalance

This method returns address balance

### Example JSON-RPC call

```json
{
  "jsonrpc": "2.0",
  "method": "getaddressbalance",
  "params": ["N3VCAvZyhnoFabFTfeWvY7WYoXQQ8ZC"],
  "id": 15
}
```

### Example JSON-RPC result

```json
{
  "jsonrpc": "2.0",
  "result": [
    {
      "valid": true,
      "address": "N3VCAvZyhnoFabFTfeWvY7WYoXQQ8ZC",
      "alias": "",
      "balance": 0,
      "incoming": 0,
      "outgoing": 0
    }
  ],
  "id": 1
}
```

### Example JSON-RPC error

```json
{
  "jsonrpc": "2.0",
  "result": [
    {
      "valid": false,
      "address": "N3VCAvZyhnoFabFTfeWvY7WYoXQQ8ZC",
      "alias": null,
      "balance": 0,
      "incoming": 0,
      "outgoing": 0
    }
  ],
  "id": 15
}
```

# getnewaddress

This method creates addresses in your wallet and returns their hashes

> In the parameters, you can specify the required number of addresses, the maximum number of addresses per operation is 100

### Example JSON-RPC call

```json
{
  "jsonrpc": "2.0",
  "method": "getnewaddress",
  "params": ["2"],
  "id": 15
}
```

### Example JSON-RPC result

```json
{
  "jsonrpc": "2.0",
  "result": [
    {
      "addresses": [
        "N3DXseUPd8QcYf4pYoDzczPzvgJPbGD",
        "N48Jd43Th4DyDdnSezQhviPGDABRbD5"
      ]
    }
  ],
  "id": 19
}
```

# getnewaddressfull

This method creates addresses in your wallet and returns their hashes, as well as a key pair

> In the parameters, you can specify the required number of addresses, the maximum number of addresses per operation is 100

### Example JSON-RPC call

```json
{
  "jsonrpc": "2.0",
  "method": "getnewaddress",
  "params": ["2"],
  "id": 15
}
```

### Example JSON-RPC result

```json
{
  "jsonrpc": "2.0",
  "result": [
    {
      "hash": "N2hYBKfQpGEnYMqXPxCbicu577nRbES",
      "public": "BORlbsWYc/5Ev1eSCOV9PpYDd1OLolbUjG0w5XpTf7Mej0J3p/enMDBKPuCc8fvwATCMKiP/jZEYX/KDXvxZ80o=",
      "private": "P/SeOHfSXAJjuCcmCmF+pcB1BKkfCZhgsWn75ooZyBA="
    },
    {
      "hash": "N2cszwqqH1a6TJ6oLkvipbs6nTnGkGe",
      "public": "BJEhIDB1mH7/6ZcJsATU0wQRSh97cReLDmBXT9XepRvgmrsdFVAzgN96vvENsDcRg4S3Li6K9Xvvx5CHoiOqZI0=",
      "private": "lUSSF7/xEJoxjweB0c1/SWwcduM10GUiw85O2EgbIFk="
    }
  ],
  "id": 1
}
```

# islocaladdress

Validate address keys are physically present on node disk

### Example JSON-RPC call

```json
{
  "jsonrpc": "2.0",
  "method": "islocaladdress",
  "params": ["N3VCAvZyhnoFabFTfeWvY7WYoXQQ8ZC"],
  "id": 15
}
```

### Example JSON-RPC result

```json
{
  "jsonrpc": "2.0",
  "result": [
    {
      "result": true
    }
  ],
  "id": 1
}
```

# getwalletbalance

Show total balance of the RPC wallet

### Example JSON-RPC call

```json
{
  "jsonrpc": "2.0",
  "method": "getwalletbalance",
  "params": [],
  "id": 15
}
```

### Example JSON-RPC result

```json
{
  "jsonrpc": "2.0",
  "result": [
    {
      "balance": 0
    }
  ],
  "id": 1
}
```

# setdefault

Sets the send from address of your RPC wallet

### Example JSON-RPC call

```json
{
  "jsonrpc": "2.0",
  "method": "setdefault",
  "params": ["N3VCAvZyhnoFabFTfeWvY7WYoXQQ8ZC"],
  "id": 15
}
```

### Example JSON-RPC result

```json
{
  "jsonrpc": "2.0",
  "result": [
    {
      "result": true
    }
  ],
  "id": 1
}
```

# sendfunds (transfer)

Send funds to an address.

> Note Noso has 8 decimals. When using rpc, to send 1 Noso you would send 100000000.

### Example JSON-RPC call

```json
{
  "jsonrpc": "2.0",
  "method": "transfer",
  "params": ["N3VCAvZyhnoFabFTfeWvY7WYoXQQ8ZC", "100000000", "Reference"],
  "id": 15
}
```

### Example JSON-RPC result

```json
{
  "jsonrpc": "2.0",
  "result": [
    {
      "valid": true,
      "result": "OR2upgmg8vqs1ypx3uk4k51xxbm27c94peib7w0t7hgvf2wj8dja"
    }
  ],
  "id": 1
}
```

# restart

Reconnect to the noso local network, if necessary. The last network node and the reconnection status are returned.

### Example JSON-RPC call

```json
{
  "jsonrpc": "2.0",
  "method": "restart",
  "params": [""],
  "id": 15
}
```

### Example JSON-RPC result

```json
{
  "jsonrpc": "2.0",
  "result": [
    {
      "lastSeed": "5.189.189.237:8082",
      "valid": true
    }
  ],
  "id": 1
}
```
