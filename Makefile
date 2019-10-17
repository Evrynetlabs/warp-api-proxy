OS_NAME := $(shell uname -s | tr A-Z a-z)

.PHONY: run

run:
ifeq ($(OS_NAME), linux-gnu)
	HOST=localhost docker-compose up --build
else
	HOST=host.docker.internal docker-compose up --build
endif

