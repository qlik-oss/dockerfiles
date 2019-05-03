FROM alpine:3.9.3
MAINTAINER Masaru Hoshi <hoshi@hoshi.com.br>

RUN apk add --no-cache curl
    rm -fr /var/cache/apk/*

ENTRYPOINT ["/usr/bin/curl"]
