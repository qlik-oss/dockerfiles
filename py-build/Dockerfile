FROM hairyhenderson/gomplate:v3.8.0-slim AS gomplate
FROM docker:20.10.7 AS docker
FROM docker/compose:1.27.4 AS compose
FROM vault:1.7.3 AS vault
FROM hashicorp/terraform:1.0.0 AS terraform
FROM hashicorp/packer:1.6.6 AS packer
FROM prom/prometheus:v2.23.0 AS prometheus
FROM prom/alertmanager:v0.21.0 AS alertmanager
FROM mikefarah/yq:4.9.6 AS yq
FROM lachlanevenson/k8s-kubectl:v1.20.1 AS kubectl
FROM lachlanevenson/k8s-helm:v3.10.2 AS helm2
FROM lachlanevenson/k8s-helm:v3.8.0 AS helm

FROM alpine:3.12.3 AS cc-test-reporter

RUN wget -q -O /bin/cc-test-reporter https://codeclimate.com/downloads/test-reporter/test-reporter-latest-linux-amd64
RUN chmod +x /bin/cc-test-reporter

FROM alpine:3.12.3 AS packages

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
    libgcc

ENV GLIBC=2.28-r0

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

FROM python:3.8.3-alpine3.12 AS pypackages

COPY requirements.txt .
RUN pip install -r requirements.txt
RUN rm requirements.txt

FROM python:3.8.3-alpine3.12 AS build

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

COPY --from=packages / /
COPY --from=pypackages / /
