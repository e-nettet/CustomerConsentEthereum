FROM enettet/ethereum-base

ADD genesis.json /etc/ethereum/genesis.json
ADD geth-init.sh /usr/bin/geth-init

ENTRYPOINT ["/usr/bin/geth-init", "/usr/bin/geth"]
