FROM ethereum-node

RUN apt-get install -q -y bootnode
ADD boot.key /etc/ethereum/boot.key

ENTRYPOINT ["/usr/bin/bootnode"]
