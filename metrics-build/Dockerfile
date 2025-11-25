FROM hairyhenderson/gomplate:v3.11.7-slim AS gomplate
FROM docker:29.0.4 AS docker
FROM hashicorp/vault:1.21.1 AS vault
FROM hashicorp/terraform:1.14.0 AS terraform
FROM prom/prometheus:v3.7.3 AS prometheus
FROM prom/alertmanager:v0.29.0 AS alertmanager
FROM grafana/mimirtool:3.0.0 AS mimirtool

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
COPY --from=prometheus /bin/promtool /bin/promtool
COPY --from=alertmanager /bin/amtool /bin/amtool
COPY --from=mimirtool /bin/mimirtool /bin/mimirtool

COPY --from=packages / /
