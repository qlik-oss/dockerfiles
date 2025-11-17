FROM hairyhenderson/gomplate:v3.11.7-slim AS gomplate
FROM docker:29.0.1 AS docker
FROM docker/compose:1.29.2 AS compose
FROM vault:1.13.3 AS vault
FROM hashicorp/terraform:1.13.5 AS terraform
FROM hashicorp/packer:1.14.2 AS packer
FROM prom/prometheus:v3.7.3 AS prometheus
FROM prom/alertmanager:v0.29.0 AS alertmanager
FROM grafana/cortex-tools:v0.11.3 AS cortextool
FROM grafana/mimirtool:3.0.0 AS mimirtool
FROM mikefarah/yq:4.48.2 AS yq
FROM gcr.io/google.com/cloudsdktool/cloud-sdk:371.0.0-alpine AS google-cloud-sdk
FROM instrumenta/conftest:v0.21.0 AS conftest

FROM alpine:3.22 AS packages

RUN apk add --no-cache \
    aws-cli \
    bash \
    curl \
    git \
    github-cli \
    jq \
    libgcc \
    make \
    openssh \
    py3-pip \
    python3

RUN mkdir hub && \
    wget https://github.com/github/hub/releases/download/v2.14.2/hub-linux-amd64-2.14.2.tgz -O- | \
    tar xz --strip-components 1 --directory hub \
    && ./hub/install \
    && rm -r hub

FROM packages AS kubectl

ARG ARCH="amd64"
ARG KUBECTL_VERSION=v1.29.7
RUN apk add --no-cache ca-certificates curl && \
    curl -sSL -o /kubectl "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${ARCH}/kubectl" && \
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
