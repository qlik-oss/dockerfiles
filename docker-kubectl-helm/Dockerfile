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

FROM golang:1.25-alpine3.22 AS build

FROM docker:dind as docker-kubectl-helm

RUN apk add --update ca-certificates \
 && apk add --no-cache curl make lz4 bash socat \
 && apk add --update -t deps

COPY --from=kubectl /kubectl /usr/local/bin/kubectl
COPY --from=helm /usr/bin/helm /usr/bin/helm

