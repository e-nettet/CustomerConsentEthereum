FROM enettet/ethereum-base

ADD genesis.json /etc/ethereum/genesis.json
ADD geth-init.sh /usr/bin/geth-init
ADD static-nodes.json /etc/ethereum/static-nodes.json
ADD static-nodes.json /etc/ethereum/trusted-nodes.json

ENTRYPOINT ["/usr/bin/geth-init", "/usr/bin/geth"]
