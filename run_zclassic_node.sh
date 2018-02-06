#!/bin/bash

# Download latest zclassic.conf
wget -q https://github.com/z-classic/zclassic/releases/download/Config/zclassic.conf -O /home/zcluser/.zclassic/zclassic.conf

# Update RPC username and password
RPCUSER=zcluser
RPCPASS=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)
sed -ie s/rpcuser=change-this/rpcuser=${RPCUSER}/ /home/zcluser/.zclassic/zclassic.conf
sed -ie s/rpcpassword=change-this/rpcpassword=${RPCPASS}/ /home/zcluser/.zclassic/zclassic.conf

mkdir -p ~/.zclassic/
/home/zcluser/zclassic/src/zcashd -daemon -conf=/home/zcluser/.zclassic/zclassic.conf -datadir=/home/zcluser/database
