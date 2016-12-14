#!/bin/sh

[ -d /root/.ethereum/geth ] || $1 init /etc/ethereum/genesis.json && cp /etc/ethereum/static-nodes.json /root/.ethereum/static-nodes.json && cp /etc/ethereum/trusted-nodes.json /root/.ethereum/trusted-nodes.json
eval "$@"
