all: ethereum-base ethereum-node ethereum-bootnode ethereum-netstats consent-wallet
nodes: ethereum-node ethereum-bootnode
ethereum-base:
	docker build -t ethereum-base base
	docker tag ethereum-base enettet/ethereum-base
ethereum-node: ethereum-base
	docker build -t ethereum-node node
	docker tag ethereum-node enettet/ethereum-node
ethereum-bootnode: ethereum-node
	docker build -t ethereum-bootnode bootnode
	docker tag ethereum-bootnode enettet/ethereum-bootnode
ethereum-netstats: ethereum-netstats
	docker build -t ethereum-netstats eth-netstats
	docker tag ethereum-netstats enettet/ethereum-netstats
	docker build -t ethereum-netstats-api eth-net-intelligence-api
	docker tag ethereum-netstats-api enettet/ethereum-netstats-api
consent-wallet:
	docker build -t consent-wallet wallet
	docker tag consent-wallet enettet/consent-wallet
push:
	docker push enettet/ethereum-base
	docker push enettet/ethereum-node
	docker push enettet/ethereum-bootnode
	docker push enettet/ethereum-netstats
	docker push enettet/ethereum-netstats-api
	docker push enettet/consent-wallet
