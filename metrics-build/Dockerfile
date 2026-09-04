FROM hairyhenderson/gomplate:v3.11.7-slim AS gomplate
FROM docker:29.8.0 AS docker
FROM hashicorp/vault:1.21.4 AS vault
FROM hashicorp/terraform:1.16.1 AS terraform
FROM prom/prometheus:v3.14.0 AS prometheus
FROM prom/alertmanager:v0.34.0 AS alertmanager
FROM grafana/mimirtool:3.2.0 AS mimirtool

FROM alpine:3.24 AS packages

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

FROM alpine:3.24 AS build

COPY --from=gomplate /gomplate /bin/gomplate
COPY --from=docker /usr/local/bin/docker /bin/docker
COPY --from=vault /bin/vault /bin/vault
COPY --from=terraform /bin/terraform /bin/terraform
COPY --from=prometheus /bin/promtool /bin/promtool
COPY --from=alertmanager /bin/amtool /bin/amtool
COPY --from=mimirtool /bin/mimirtool /bin/mimirtool

COPY --from=packages / /
