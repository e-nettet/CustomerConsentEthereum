#!/bin/sh

[ -d /root/.ethereum/geth ] || geth init /etc/ethereum/genesis.json
eval "$@"
