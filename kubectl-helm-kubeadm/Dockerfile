
FROM lachlanevenson/k8s-kubectl:v1.14.0 AS kubectl
FROM lachlanevenson/k8s-helm:v2.13.1 AS helm

FROM mirantis/kubeadm-dind-cluster:76f7b8a5f3966aa80700a8c9f92d23f6936f949b-v1.13 as kubeadm-dind-cluster
RUN apt-get update && apt-get -y install nfs-common

FROM docker:dind as docker-kubectl-helm

RUN apk add --update ca-certificates \
 && apk add --no-cache curl make lz4 bash socat \
 && apk add --update -t deps 

COPY --from=kubectl /usr/local/bin/kubectl /usr/local/bin/kubectl
COPY --from=helm /usr/local/bin/helm /usr/local/bin/helm 

FROM docker-kubectl-helm as kubectl-helm-kubeadm

ENV DIND_IMAGE="qlik/kubeadm-dind-cluster"
ENV KUBEADMIN_DIND_CLUSTER="/kubeadm-dind-cluster"

COPY . /


