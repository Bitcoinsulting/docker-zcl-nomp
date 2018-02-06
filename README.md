# docker-zcl-nomp
This is a docker image to run complete [Zclassic mining pool](https://github.com/BTCP-community/z-nomp).

## Components included
* ZClassic full node
* Node JS, NPM
* Redis
* LevelDB

## Building Docker

1. Clone this repo
```
$ git clone git@github.com:rizkiwicaksono/docker-zcl-nomp.git
```

2. Build from Dockerfile
```
$ cd docker-zcl-nomp/
$ docker build -t btcp/z-nomp .
```


## Running Z-NOMP docker

Requirement:
* Make sure you have a folder to hold zcl blockchain
```
$ mkdir {absolute/path/to/zcl-blockchain/folder}
```

Running Docker

```
$ docker run -v {absolute/path/to/zcl-blockchain/folder}:/home/zcluser/database -it -t btcp/z-nomp /bin/bash
root@2b8bf0547d53:/home/zcluser# bash ./run_zcl_nomp.sh
```

![](https://user-images.githubusercontent.com/4344115/35842844-b5c31d48-0ab9-11e8-91c6-f289c404d5fc.png)

## Verify your ZCL node is running
We can verify ZCL node by sending RPC command getinfo to ZCL node. If you get the following results, then your ZCL node is running.
```
$ curl http://127.0.0.1:8232 --user zcluser:[RPCpassword] --data-binary '{"id": 0, "method": "getinfo", "params": []}'

{"result":{"version":1001051,"protocolversion":170002,"walletversion":60000,"balance":0.00000000,"blocks":245515,"timeoffset":-6,"connections":8,"proxy":"","difficulty":1652238.118018669,"testnet":false,"keypoololdest":1517647133,"keypoolsize":101,"paytxfee":0.00000000,"relayfee":0.00000100,"errors":""},"error":null,"id":0}
```


## Troubleshootings

1. RPC call connection refused

![invalid port](https://user-images.githubusercontent.com/4344115/35867293-47fee076-0b0e-11e8-854a-2156b57175d5.png)
```
2018-02-03 17:10:26 [Pool]	[zclassic] (Thread 2) Could not start pool, error with init batch RPC call: {"type":"offline","message":"connect ECONNREFUSED 127.0.0.1:8023"}
```

This error caused by incorrect RPC port was configured in pool_configs/zclassic.json. Find out the correct RPC port in your zclassic.conf file (begin with "rpcport=") then fix port number in pool_configs/zclassic.json under payment processing:

```json
    "paymentProcessing": {
    "minConf": 10,
        "enabled": true,
        "paymentMode": "prop",
        "_comment_paymentMode":"prop, pplnt",
        "paymentInterval": 15,
        "minimumPayment": 0,
        "maxBlocksPerPayment": 1000,
        "daemon": {
            "host": "127.0.0.1",
            "port": 8232,
            "user": "zcluser",
            "password": "EuStKJZe"
        }
    },
```

and also change port number under daemons section:
```json
    "daemons": [
        {
            "host": "127.0.0.1",
            "port": 8232,
            "user": "zcluser",
            "password": "EuStKJZe"
        }
    ],
```

2. Invalid address

![invalid address](https://user-images.githubusercontent.com/4344115/35867060-abdd60a0-0b0d-11e8-8a90-f8730d1991b3.png)

```
2018-02-03 17:12:27 [Payments]	[zclassic] Daemon does not own pool address - payment processing can not be done with this daemon, {"isvalid":true,"address":"t1a4ZTJTeCwnE9saExJ765pqmncJaT8vacM","scriptPubKey":"76a914b1947522d1058216bebd58afd34ffa10e45bb83f88ac","ismine":false,"iswatchonly":false,"isscript":false}
2018-02-03 17:12:27 [Website]	[zclassic] Could not dumpprivkey for zclassic {"code":-4,"message":"Private key for address t1a4ZTJTeCwnE9saExJ765pqmncJaT8vacM is not known"}
```
This error caused by addresses set up in pool_configs/zclassic.json was not generated from zcl-daemon. Fix your address, tAddress, and zAddress in pool_configs/zclassic.json with the output of the following commands:

```
$ /home/zcluser/zclassic/src/zcash-cli -conf=/home/zcluser/.zclassic/zclassic.conf getnewaddress # put in "address"
$ /home/zcluser/zclassic/src/zcash-cli -conf=/home/zcluser/.zclassic/zclassic.conf getnewaddress # put in "tAddress"
$ /home/zcluser/zclassic/src/zcash-cli -conf=/home/zcluser/.zclassic/zclassic.conf z_getnewaddress # put in "zAddress"
```

3. Node not connected

![zcash not connected](https://user-images.githubusercontent.com/4344115/35866736-ce1c8412-0b0c-11e8-9ba3-c8cc22846842.png)

This error caused by your zclassic node is not yet connected to any peers. Most of the case, it just need more time to try all nodes IP addresses in zclassic.conf file.

4. Downloading blockchain

![syncing blockchain](https://user-images.githubusercontent.com/4344115/35866858-1979beca-0b0d-11e8-859a-8dd41a3ed5a1.png)

This is not an error, you have to wait until your zcl node has downloaded full blockchain before pool can be started.






