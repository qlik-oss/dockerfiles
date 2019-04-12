FROM docker:dind as docker-kubectl-helm

ARG K8S_VERSION
ARG HELM_VERSION
ENV HELM_FILENAME=helm-v${HELM_VERSION}-linux-amd64.tar.gz

RUN apk add --update ca-certificates \
 && apk add --no-cache curl make lz4 bash socat \
 && apk add --update -t deps \
 && apk add --update gettext tar gzip \
 && curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
 && chmod +x ./kubectl \
 && mv ./kubectl /usr/local/bin/kubectl 

 Run curl -L https://storage.googleapis.com/kubernetes-helm/${HELM_FILENAME} | tar xz && mv linux-amd64/helm /bin/helm && rm -rf linux-amd64 \
 && apk del --purge deps \
 && rm /var/cache/apk/*