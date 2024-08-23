FROM alpine:3.18.2
ENV PKI_DIR=/etc/pki
ENV CA_DIR=$PKI_DIR/ca
ENV RADSECPROXY_DIR=/etc/radsecproxy
RUN apk update && apk add \
radsecproxy \
envsubst \
bind-tools \
bash \
openssl && \
mkdir -p $RADSECPROXY_DIR && \
mkdir -p $PKI_DIR && \
mkdir -p $CA_DIR
COPY pki/roots/ $CA_DIR/
COPY config/ $RADSECPROXY_DIR/
COPY entrypoint.sh /
RUN openssl rehash $CA_DIR
CMD ["sh", "/entrypoint.sh"]
EXPOSE 1812/udp
EXPOSE 1813/udp
