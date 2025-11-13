FROM hairyhenderson/gomplate:v3.11.6-slim AS gomplate
FROM docker:27.5.0 AS docker
FROM docker/compose:1.29.2 AS compose
FROM vault:1.10.11 AS vault
FROM hashicorp/terraform:1.6.6 AS terraform
FROM hashicorp/packer:1.11.2 AS packer
FROM prom/prometheus:v2.53.2 AS prometheus
FROM prom/alertmanager:v0.27.0 AS alertmanager
FROM grafana/cortex-tools:v0.11.2 AS cortextool
FROM grafana/mimirtool:2.12.0 AS mimirtool
FROM mikefarah/yq:4.44.3 AS yq
FROM gcr.io/google.com/cloudsdktool/cloud-sdk:371.0.0-alpine AS google-cloud-sdk
FROM instrumenta/conftest:v0.21.0 AS conftest

FROM alpine:3.22 AS packages

RUN apk add --no-cache \
    make \
    git \
    libgcc \
    python3 \
    py3-pip \
    bash \
    jq \
    curl \
    openssh \
    github-cli

ENV GLIBC=2.35-r1

RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub

COPY awscli-requirements.txt requirements.txt
RUN pip3 install -r requirements.txt --break-system-packages
RUN rm -rf requirements.txt ~/.cache

RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC/glibc-$GLIBC.apk \
  && apk add --no-cache glibc-$GLIBC.apk \
  && rm glibc-$GLIBC.apk \
  && ln -s /lib/libz.so.1 /usr/glibc-compat/lib \
  && ln -s /lib/libc.musl-x86_64.so.1 /usr/glibc-compat/lib \
  && ln -s /usr/lib/libgcc_s.so.1 /usr/glibc-compat/lib

RUN mkdir hub && \
    wget https://github.com/github/hub/releases/download/v2.12.2/hub-linux-amd64-2.12.2.tgz -O- | \
    tar xz --strip-components 1 --directory hub \
    && ./hub/install \
    && rm -r hub

FROM packages AS kubectl

ARG ARCH="amd64"
ARG KUBECTL_VERSION=v1.29.7
RUN apk add --no-cache ca-certificates curl && \
    curl -sSL -o /kubectl "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${KARCH}/kubectl" && \
    chmod +x /kubectl

FROM packages AS helm

ARG ARCH="amd64"
ARG HELM_LATEST_VERSION="v3.17.3"

RUN apk add --update --no-cache ca-certificates wget \
    && wget -q https://get.helm.sh/helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz \
    && tar -xf helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz \
    && mv linux-amd64/helm /usr/bin/helm \
    && rm -Rf helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz linux-amd64

FROM packages AS build

COPY --from=gomplate /gomplate /bin/gomplate
COPY --from=docker /usr/local/bin/docker /bin/docker
COPY --from=vault /bin/vault /bin/vault
COPY --from=terraform /bin/terraform /bin/terraform
COPY --from=packer /bin/packer /bin/packer
COPY --from=prometheus /bin/promtool /bin/promtool
COPY --from=alertmanager /bin/amtool /bin/amtool
COPY --from=cortextool /usr/bin/cortextool /bin/cortextool
COPY --from=mimirtool /bin/mimirtool /bin/mimirtool
COPY --from=yq /usr/bin/yq /usr/bin/yq
COPY --from=compose /usr/local/bin/docker-compose /bin/docker-compose
COPY --from=kubectl /kubectl /usr/local/bin/kubectl
COPY --from=helm /usr/bin/helm /usr/local/bin/helm
COPY --from=google-cloud-sdk /google-cloud-sdk/bin/ /usr/local/bin/
COPY --from=google-cloud-sdk /google-cloud-sdk/lib/ /usr/local/lib/
COPY --from=google-cloud-sdk /google-cloud-sdk/platform/ /usr/local/platform/
COPY --from=google-cloud-sdk /google-cloud-sdk/.install/ /usr/local/.install/
COPY --from=conftest /usr/local/bin/conftest /usr/local/bin/conftest

COPY --from=packages / /
