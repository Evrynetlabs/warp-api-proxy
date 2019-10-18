FROM envoyproxy/envoy:latest

COPY ./config.yaml /config.yaml

COPY ./scripts/grpcwebproxy.sh /grpcwebproxy.sh

RUN chmod +x /grpcwebproxy.sh

CMD ["/grpcwebproxy.sh"]