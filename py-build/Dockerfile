FROM hairyhenderson/gomplate:v3.5.0-slim AS gomplate
FROM docker:18.09.7 AS docker
FROM docker/compose:1.24.1 AS compose
FROM vault:0.11.6 AS vault
FROM hashicorp/terraform:0.12.4 AS terraform
FROM hashicorp/packer:1.4.2 AS packer
FROM prom/prometheus:v2.11.1 AS prometheus
FROM prom/alertmanager:v0.18.0 AS alertmanager
FROM mikefarah/yq:2.4.0 AS yq
FROM lachlanevenson/k8s-kubectl:v1.15.0 AS kubectl
FROM lachlanevenson/k8s-helm:v2.14.2 AS helm

FROM alpine:3.10 AS packages

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
    python \
    py2-pip \
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

FROM python:3-alpine3.8 AS pypackages

COPY requirements.txt .
# Hack to workaround astroid->typed_ast dependency on gcc
RUN python -c 'import sys; f = open("/usr/local/lib/python3.7/site-packages/_manylinux.py", "w"); f.write("manylinux1_compatible = True"); f.close()'
RUN pip install -r requirements.txt
RUN rm requirements.txt

FROM python:3-alpine3.8 AS build

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
COPY --from=helm /usr/local/bin/helm /usr/local/bin/helm 

COPY --from=packages / /
COPY --from=pypackages / /
