FROM hairyhenderson/gomplate:v3.11.7-slim AS gomplate
FROM docker:27.3.1 AS docker
FROM hashicorp/vault:1.18.0 AS vault
FROM hashicorp/terraform:1.9.7 AS terraform
FROM bitnami/prometheus:2.54.1 AS prometheus
FROM bitnami/alertmanager:0.27.0 AS alertmanager
FROM grafana/mimirtool:2.14.0 AS mimirtool

FROM alpine:3.20 AS packages

RUN apk add --no-cache \
    make \
    git \
    python3 \
    py3-pip \
    bash \
    jq \
    curl \
    openssh \
    github-cli

FROM alpine:3.20 AS build

COPY --from=gomplate /gomplate /bin/gomplate
COPY --from=docker /usr/local/bin/docker /bin/docker
COPY --from=vault /bin/vault /bin/vault
COPY --from=terraform /bin/terraform /bin/terraform
COPY --from=prometheus /opt/bitnami/prometheus/bin/promtool /bin/promtool
COPY --from=alertmanager /opt/bitnami/alertmanager/bin/amtool /bin/amtool
COPY --from=mimirtool /bin/mimirtool /bin/mimirtool

COPY --from=packages / /
