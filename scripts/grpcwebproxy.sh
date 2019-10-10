#!/bin/bash

COMMAND=$1
IMAGE_NAME="warp/grpcwebproxy"
if [[ ! "$2" == "" ]]; then
  IMAGE_NAME="$2"
fi
CONTAINER_NAME="grpcwebproxy"

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

case "$COMMAND" in
  build) 
    if [ "$OSTYPE" == "linux-gnu" ]; then
      sed 's/HOST_ADDRESS/localhost/g' config.yaml > envoy.yaml
    else
      sed 's/HOST_ADDRESS/host.docker.internal/g' config.yaml > envoy.yaml
    fi
    
    eval "docker build -t $IMAGE_NAME -f Dockerfile ." 
    ;;
  start | run)
    runDependsOnOS \
        "docker run -it --rm --name $CONTAINER_NAME --net=host -p 9090:9090 $IMAGE_NAME" \
        "docker run -it --rm --name $CONTAINER_NAME -p 9090:9090 $IMAGE_NAME"
    ;;
    
  stop)
      docker stop $CONTAINER_NAME
    ;;
  remove)
      docker rmi $IMAGE_NAME
    ;;
  *)
    usage
    ;;
esac