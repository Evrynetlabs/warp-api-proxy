#!/bin/bash

COMMAND=$1

function usage() {
  echo -n "
grpcwebproxy COMMAND [OPTION]...

This is the gRPC-web proxy utility.

 Command:
  build     Create a new gRPC-web proxy image
  run       Start the gRPC-web proxy container
  stop      Stop the gRPC-web proxy container
  remove    Remove the gRPC-web proxy container
"
}

function runDependsOnOS() {
  case "$OSTYPE" in
      "linux")
        eval $1
        ;;
      *)
        eval $2
        ;;
  esac
}

if [[ -z "$COMMAND" ]]; then
  usage
  exit
fi

case "$1" in
  build) 
    if [ "$OSTYPE" == "linux-gnu" ]; then
      sed 's/HOST_ADDRESS/localhost/g' config.yaml > envoy.yaml
    else
      sed 's/HOST_ADDRESS/host.docker.internal/g' config.yaml > envoy.yaml
    fi
    eval "docker build -t grpc-web-proxy -f Dockerfile ." 
    ;;
  start | run)
    runDependsOnOS \
        "docker run -it --rm --name grpcwebproxy --net=host -p 9090:9090 grpc-web-proxy" \
        "docker run -it --rm --name grpcwebproxy -p 9090:9090 grpc-web-proxy"
    ;;
    
  stop)
      docker stop grpcwebproxy
    ;;
  remove)
      docker rmi grpc-web-proxy
    ;;
  *)
    usage
    ;;
esac