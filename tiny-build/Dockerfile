FROM hairyhenderson/gomplate:v3.0.0-slim AS gomplate
FROM docker:18.09 AS docker
FROM docker/compose:1.23.1 AS compose
FROM vault:0.11.4 AS vault
FROM hashicorp/terraform:light AS terraform
FROM hashicorp/packer:light AS packer
FROM prom/prometheus:v2.5.0 AS prometheus

FROM alpine:3.8 AS build

RUN apk add --no-cache \
    make \
    git \
    libgcc

ENV GLIBC=2.28-r0

RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub

RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC/glibc-$GLIBC.apk \
  && apk add --no-cache glibc-$GLIBC.apk \
  && rm glibc-$GLIBC.apk \
  && ln -s /lib/libz.so.1 /usr/glibc-compat/lib \
  && ln -s /lib/libc.musl-x86_64.so.1 /usr/glibc-compat/lib \
  && ln -s /usr/lib/libgcc_s.so.1 /usr/glibc-compat/lib

COPY --from=gomplate /gomplate /bin/gomplate
COPY --from=docker /usr/local/bin/docker /bin/docker
COPY --from=vault /bin/vault /bin/vault
COPY --from=terraform /bin/terraform /bin/terraform
COPY --from=packer /bin/packer /bin/packer
COPY --from=prometheus /bin/promtool /bin/promtool

COPY --from=compose /usr/local/bin/docker-compose /bin/docker-compose
