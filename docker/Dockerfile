FROM golang:1.13.0-alpine3.10

ENV GOPATH /go
ENV PATH ${GOPATH}/bin:$PATH

ARG backend_addr
ENV BACKEND_ADDR ${backend_addr} 

# Update OS package and install Git
RUN apk update && \
    apk add git 

# Install dep
RUN go get -u github.com/golang/dep/cmd/dep

# Get grpc-web
RUN git clone https://github.com/improbable-eng/grpc-web.git $GOPATH/src/github.com/improbable-eng/grpc-web

WORKDIR ${GOPATH}/src/github.com/improbable-eng/grpc-web

RUN dep ensure
RUN go install ./go/grpcwebproxy

WORKDIR ${GOPATH}/bin

EXPOSE 9090

CMD ./grpcwebproxy --backend_addr=${BACKEND_ADDR} --run_tls_server=false --allow_all_origins --server_http_debug_port=9090 --server_http_max_write_timeout=1m
