all: ethereum-base ethereum-node ethereum-bootnode
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
push:
	docker push enettet/ethereum-base
	docker push enettet/ethereum-node
	docker push enettet/ethereum-bootnode
