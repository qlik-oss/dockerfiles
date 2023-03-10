FROM hairyhenderson/gomplate:v3.10.0-slim AS gomplate
FROM docker:20.10.12 AS docker
FROM docker/compose:1.29.2 AS compose
FROM vault:1.9.3 AS vault
FROM hashicorp/terraform:1.1.5 AS terraform
FROM hashicorp/packer:1.7.10 AS packer
FROM prom/prometheus:v2.33.1 AS prometheus
FROM prom/alertmanager:v0.23.0 AS alertmanager
FROM mikefarah/yq:4.18.1 AS yq
FROM lachlanevenson/k8s-kubectl:v1.21.9 AS kubectl
FROM lachlanevenson/k8s-helm:v3.10.2 AS helm2
FROM lachlanevenson/k8s-helm:v3.8.0 AS helm
FROM golangci/golangci-lint:v1.44.0-alpine AS golangci-lint

FROM alpine:3.15 AS cc-test-reporter

RUN wget -q -O /bin/cc-test-reporter https://codeclimate.com/downloads/test-reporter/test-reporter-latest-linux-amd64
RUN chmod +x /bin/cc-test-reporter

FROM alpine:3.15 AS packages

RUN apk add --no-cache \
    zip \
    unzip \
    bats \
    bash \
    grep \
    sed \
    make \
    jq \
    curl \
    git \
    python3 \
    py3-pip \
    openssh-client \
    openssl \
    libgcc \
    build-base

ENV GLIBC=2.31-r0

RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub

COPY awscli-requirements.txt requirements.txt
RUN pip install -r requirements.txt
RUN rm -rf requirements.txt ~/.cache

RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC/glibc-$GLIBC.apk \
  && apk add --no-cache glibc-$GLIBC.apk \
  && rm glibc-$GLIBC.apk \
  && ln -s /lib/libz.so.1 /usr/glibc-compat/lib \
  && ln -s /lib/libc.musl-x86_64.so.1 /usr/glibc-compat/lib \
  && ln -s /usr/lib/libgcc_s.so.1 /usr/glibc-compat/lib

FROM golang:1.18.1-alpine AS build

COPY --from=gomplate /gomplate /bin/gomplate
COPY --from=docker /usr/local/bin/docker /bin/docker
COPY --from=vault /bin/vault /bin/vault
COPY --from=terraform /bin/terraform /bin/terraform
COPY --from=packer /bin/packer /bin/packer
COPY --from=prometheus /bin/promtool /bin/promtool
COPY --from=alertmanager /bin/amtool /bin/amtool
COPY --from=yq /usr/bin/yq /usr/bin/yq
COPY --from=compose /usr/local/bin/docker-compose /bin/docker-compose
COPY --from=kubectl /usr/local/bin/kubectl /usr/local/bin/kubectl
COPY --from=helm2 /usr/local/bin/helm /usr/local/bin/helm2
COPY --from=helm /usr/local/bin/helm /usr/local/bin/helm
COPY --from=cc-test-reporter /bin/cc-test-reporter /bin/cc-test-reporter
COPY --from=golangci-lint /usr/bin/golangci-lint /bin/

COPY --from=packages / /
