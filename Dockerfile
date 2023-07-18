FROM alpine:3.18.2
ENV PKI_DIR=/etc/pki
ENV RADSECPROXY_DIR=/etc/radsecproxy
RUN apk update && apk add \
radsecproxy \
envsubst \
bind-tools \
bash && \
mkdir -p $RADSECPROXY_DIR && \
mkdir -p $PKI_DIR
COPY pki/ca.crt $PKI_DIR/
COPY config/ $RADSECPROXY_DIR/
COPY entrypoint.sh /
CMD ["sh", "/entrypoint.sh"]
EXPOSE 1812/udp
EXPOSE 1813/udp
