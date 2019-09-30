.PHONY: all
all: build run

.PHONY: build
build: 
	./scripts/grpcwebproxy.sh build

.PHONY: run
run:
	./scripts/grpcwebproxy.sh run
