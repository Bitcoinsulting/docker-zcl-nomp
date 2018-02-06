#!/bin/bash

# start redis
service redis_6379 start
# start ZCL node
sudo -u zcluser ./run_zclassic_node.sh

echo "Waiting for zclassic node to bootstrap, 30s"
sleep 30

echo "Tail of ZCL node debug log"
tail /home/zcluser/database/debug.log 

# update password to zclassic.json
RPCPASS=$(grep rpcpass /home/zcluser/.zclassic/zclassic.conf|cut -f2 -d'='|tr -d '\n'|tr -d '\r')
cp /home/zcluser/zclassic-template.json /home/zcluser/zclassic.json 
sed -ie s/RPCPASS/${RPCPASS}/ zclassic.json

ADDR1=$(/home/zcluser/zclassic/src/zcash-cli -conf=/home/zcluser/.zclassic/zclassic.conf getnewaddress)
ADDR2=$(/home/zcluser/zclassic/src/zcash-cli -conf=/home/zcluser/.zclassic/zclassic.conf z_getnewaddress)
ADDR3=$(/home/zcluser/zclassic/src/zcash-cli -conf=/home/zcluser/.zclassic/zclassic.conf getnewaddress)
echo $ADDR1
echo $ADDR2
echo $ADDR3
sed -ie s/ADDR1/${ADDR1}/ zclassic.json
sed -ie s/ADDR2/${ADDR2}/ zclassic.json
sed -ie s/ADDR3/${ADDR3}/ zclassic.json

rm -rf /home/zcluser/z-nomp
git clone https://github.com/BTCP-community/z-nomp.git
cd /home/zcluser/z-nomp
git checkout production

cp /home/zcluser/zclassic.json /home/zcluser/z-nomp/pool_configs/zclassic.json
cp /home/zcluser/config.json /home/zcluser/z-nomp/config.json

chown zcluser:zcluser -R /home/zcluser/z-nomp
sudo -u zcluser npm update
sudo -u zcluser npm install
sudo -u zcluser npm start
