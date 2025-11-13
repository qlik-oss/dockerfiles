ARG KUBECTL_VERSION=v1.29.7

FROM hairyhenderson/gomplate:v3.8.0-slim AS gomplate
FROM docker:27.5.0 AS docker
FROM docker/compose:1.27.4 AS compose
FROM vault:1.7.3 AS vault
FROM hashicorp/terraform:1.0.0 AS terraform
FROM hashicorp/packer:1.6.6 AS packer
FROM prom/prometheus:v3.7.3 AS prometheus
FROM prom/alertmanager:v0.27.0 AS alertmanager
FROM mikefarah/yq:4.9.6 AS yq
FROM alpine:3.22 AS packages

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

ENV GLIBC=2.35-r1

RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub

COPY awscli-requirements.txt requirements.txt
RUN grep -v -E "^(awscli|botocore)" requirements.txt > /tmp/reqs && \
    pip3 install --upgrade pip setuptools wheel packaging --break-system-packages --no-cache-dir && \
    pip3 install -r /tmp/reqs --break-system-packages --no-cache-dir && \
    rm -rf /tmp/reqs ~/.cache
RUN rm -rf requirements.txt

RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC/glibc-$GLIBC.apk \
  && apk add --no-cache glibc-$GLIBC.apk \
  && rm glibc-$GLIBC.apk \
  && ln -s /lib/libz.so.1 /usr/glibc-compat/lib \
  && ln -s /lib/libc.musl-x86_64.so.1 /usr/glibc-compat/lib \
  && ln -s /usr/lib/libgcc_s.so.1 /usr/glibc-compat/lib

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

FROM python:3.9.25-alpine3.22 AS pypackages

COPY requirements.txt .
RUN pip3 install --upgrade pip setuptools wheel packaging --no-cache-dir && \
    pip3 install -r requirements.txt --break-system-packages --no-cache-dir
RUN rm requirements.txt

FROM python:3.9.25-alpine3.22 AS build

# Install AWS CLI v2 using the bundled installer (supports amd64 and aarch64)
ARG ARCH="amd64"
RUN case "${ARCH}" in \
            amd64|x86_64) AWS_ZIP="awscli-exe-linux-x86_64.zip" ;; \
            aarch64|arm64) AWS_ZIP="awscli-exe-linux-aarch64.zip" ;; \
            *) echo "unsupported ARCH=${ARCH}" >&2; exit 1 ;; \
        esac && \
        apk add --no-cache unzip curl && \
        curl -sSL -o /tmp/${AWS_ZIP} "https://awscli.amazonaws.com/${AWS_ZIP}" && \
        unzip /tmp/${AWS_ZIP} -d /tmp && \
        /tmp/aws/install -i /usr/local/aws-cli -b /usr/local/bin && \
        rm -rf /tmp/aws /tmp/${AWS_ZIP}

COPY --from=gomplate /gomplate /bin/gomplate
COPY --from=docker /usr/local/bin/docker /bin/docker
COPY --from=vault /bin/vault /bin/vault
COPY --from=terraform /bin/terraform /bin/terraform
COPY --from=packer /bin/packer /bin/packer
COPY --from=prometheus /bin/promtool /bin/promtool
COPY --from=alertmanager /bin/amtool /bin/amtool
COPY --from=yq /usr/bin/yq /usr/bin/yq
COPY --from=compose /usr/local/bin/docker-compose /bin/docker-compose
COPY --from=kubectl /kubectl /usr/local/bin/kubectl
COPY --from=helm /usr/bin/helm /usr/bin/helm

COPY --from=packages / /
COPY --from=pypackages / /
