FROM hairyhenderson/gomplate:v3.11.7-slim AS gomplate
FROM docker:27.5.1 AS docker
FROM hashicorp/vault:1.20.2 AS vault
FROM hashicorp/terraform:1.12.2 AS terraform
FROM bitnami/prometheus:2.55.1 AS prometheus
FROM bitnami/alertmanager:0.28.1 AS alertmanager
FROM grafana/mimirtool:2.17.0 AS mimirtool

FROM alpine:3.22 AS packages

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

FROM alpine:3.22 AS build

COPY --from=gomplate /gomplate /bin/gomplate
COPY --from=docker /usr/local/bin/docker /bin/docker
COPY --from=vault /bin/vault /bin/vault
COPY --from=terraform /bin/terraform /bin/terraform
COPY --from=prometheus /opt/bitnami/prometheus/bin/promtool /bin/promtool
COPY --from=alertmanager /opt/bitnami/alertmanager/bin/amtool /bin/amtool
COPY --from=mimirtool /bin/mimirtool /bin/mimirtool

COPY --from=packages / /
