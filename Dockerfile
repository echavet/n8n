ARG BUILD_FROM
FROM $BUILD_FROM

RUN apk add --no-cache \
    nodejs \
    npm \
    jq

RUN npm install -g n8n

EXPOSE 5678

WORKDIR /data

COPY rootfs /

#CMD ["/init"]