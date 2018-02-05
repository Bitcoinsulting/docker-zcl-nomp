# docker-zcl-nomp
Running ZClassic NOMP in a Docker container


# Verify your ZCL node is running
We can verify ZCL node by sending RPC command getinfo to ZCL node. If you get the following results, then your ZCL node is running.
```
$ curl http://127.0.0.1:8232 --user zcluser:[RPCpassword] --data-binary '{"id": 0, "method": "getinfo", "params": []}'

{"result":{"version":1001051,"protocolversion":170002,"walletversion":60000,"balance":0.00000000,"blocks":245515,"timeoffset":-6,"connections":8,"proxy":"","difficulty":1652238.118018669,"testnet":false,"keypoololdest":1517647133,"keypoolsize":101,"paytxfee":0.00000000,"relayfee":0.00000100,"errors":""},"error":null,"id":0}
```


# Troubleshootings

1. RPC call failed

```
2018-02-03 17:10:26 [Pool]	[zclassic] (Thread 2) Could not start pool, error with init batch RPC call: {"type":"offline","message":"connect ECONNREFUSED 127.0.0.1:8023"}
```

This error caused by incorrect port was configured. Daemon port number in pool_configs/zclassic.json should match .zclassic/zclassic.conf.

2. Invalid address

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

```
{"code":-9,"message":"Zcash is not connected!"}
```
This error caused by your zclassic node is not connected to any peers. Most of the case, it just need more time to try all nodes IP addresses in zclassic.conf file.







