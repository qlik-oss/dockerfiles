FROM lachlanevenson/k8s-kubectl:v1.25.4 AS kubectl
FROM lachlanevenson/k8s-helm:v3.10.2 AS helm

FROM docker:dind as docker-kubectl-helm

RUN apk add --update ca-certificates \
 && apk add --no-cache curl make lz4 bash socat \
 && apk add --update -t deps

COPY --from=kubectl /usr/local/bin/kubectl /usr/local/bin/kubectl
COPY --from=helm /usr/local/bin/helm /usr/local/bin/helm

