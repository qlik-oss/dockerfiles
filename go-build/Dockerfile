FROM golang:1.11-alpine

ENV GLIBC=2.27-r0
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
    python \
    py2-pip \
    openssh-client \
    openssl \
    libgcc
RUN pip install awscli

RUN go get -u github.com/golang/dep/cmd/dep
RUN go get -u github.com/jstemmer/go-junit-report
RUN go get -u github.com/alecthomas/gometalinter \
  && gometalinter --install

COPY --from=hairyhenderson/gomplate:v2.4.0-slim /gomplate /bin/gomplate
COPY --from=docker:17.12 /usr/local/bin/docker /bin/docker
COPY --from=vault:0.9.5 /bin/vault /bin/vault
COPY --from=hashicorp/terraform:light /bin/terraform /bin/terraform
COPY --from=hashicorp/packer:light /bin/packer /bin/packer
COPY --from=prom/prometheus:v2.2.0 /bin/promtool /bin/promtool

RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
  && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC/glibc-$GLIBC.apk \
  && apk add --no-cache glibc-$GLIBC.apk \
  && rm glibc-$GLIBC.apk \
  && ln -s /lib/libz.so.1 /usr/glibc-compat/lib \
  && ln -s /lib/libc.musl-x86_64.so.1 /usr/glibc-compat/lib \
  && ln -s /usr/lib/libgcc_s.so.1 /usr/glibc-compat/lib
COPY --from=docker/compose:1.21.0 /usr/local/bin/docker-compose /bin/docker-compose
