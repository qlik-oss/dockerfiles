FROM hairyhenderson/gomplate:v3.11.7-slim AS gomplate
FROM docker:29.2.0 AS docker
FROM hashicorp/vault:1.21.2 AS vault
FROM hashicorp/terraform:1.14.4 AS terraform
FROM prom/prometheus:v3.9.1 AS prometheus
FROM prom/alertmanager:v0.30.1 AS alertmanager
FROM grafana/mimirtool:3.0.2 AS mimirtool

FROM alpine:3.23 AS packages

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

FROM alpine:3.23 AS build

COPY --from=gomplate /gomplate /bin/gomplate
COPY --from=docker /usr/local/bin/docker /bin/docker
COPY --from=vault /bin/vault /bin/vault
COPY --from=terraform /bin/terraform /bin/terraform
COPY --from=prometheus /bin/promtool /bin/promtool
COPY --from=alertmanager /bin/amtool /bin/amtool
COPY --from=mimirtool /bin/mimirtool /bin/mimirtool

COPY --from=packages / /
