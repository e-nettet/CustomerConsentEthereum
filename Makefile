all: ethereum-base ethereum-node ethereum-bootnode
nodes: ethereum-node ethereum-bootnode
ethereum-base:
	docker build -t ethereum-base base
ethereum-node: ethereum-base
	docker build -t ethereum-node node
ethereum-bootnode: ethereum-node
	docker build -t ethereum-bootnode bootnode
