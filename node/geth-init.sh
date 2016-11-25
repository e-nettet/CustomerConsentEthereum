#!/bin/sh

[ -d /root/.ethereum/geth ] || $1 init /etc/ethereum/genesis.json
eval "$@"
