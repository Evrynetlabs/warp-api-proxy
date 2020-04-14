FROM envoyproxy/envoy:v1.14.1

COPY ./config.yaml /config.yaml

COPY ./scripts/grpcwebproxy.sh /grpcwebproxy.sh

RUN chmod +x /grpcwebproxy.sh

CMD ["/grpcwebproxy.sh"]
