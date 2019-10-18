OS_NAME := $(shell uname -s | tr A-Z a-z)

.PHONY: all
.PHONY: build
.PHONY: run
.PHONY: stop

all: build run

build:
	docker-compose build

run:
ifeq ($(OS_NAME), linux-gnu)
	HOST=localhost docker-compose up -d
else
	HOST=host.docker.internal docker-compose up -d
endif

stop:
	docker-compose down
