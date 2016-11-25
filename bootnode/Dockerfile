FROM enettet/ethereum-node

ADD boot.key /etc/ethereum/boot.key

ENTRYPOINT ["/usr/bin/geth-init", "/usr/bin/bootnode"]
