.PHONY: all
all: build run

.PHONY: build
build: 
	./scripts/grpcwebproxy.sh build $(name)

.PHONY: run
run:
	./scripts/grpcwebproxy.sh run $(name)

.PHONY: clean
clean:
	./scripts/grpcwebproxy.sh remove $(name)