FROM enettet/ethereum-base

ADD genesis.json /etc/ethereum/genesis.json
RUN geth init /etc/ethereum/genesis.json

ENTRYPOINT ["/usr/bin/geth"]
