all: ethereum-base ethereum-node ethereum-bootnode ethereum-netstats
nodes: ethereum-node ethereum-bootnode
ethereum-base:
	docker build -t ethereum-base base
ethereum-node: ethereum-base
	docker build -t ethereum-node node
ethereum-bootnode: ethereum-node
	docker build -t ethereum-bootnode bootnode
ethereum-netstats: ethereum-netstats
	docker build -t ethereum-netstats eth-netstats
	docker build -t ethereum-netstats-api eth-net-intelligence-api
