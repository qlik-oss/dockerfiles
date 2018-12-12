FROM alpine:3.7

ENV GLIBC=2.27-r0

RUN apk add --no-cache \
    make \
    git \
    libgcc

COPY --from=hairyhenderson/gomplate:v2.4.0-slim /gomplate /bin/gomplate
COPY --from=docker:17.12 /usr/local/bin/docker /bin/docker

RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
  && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC/glibc-$GLIBC.apk \
  && apk add --no-cache glibc-$GLIBC.apk \
  && rm glibc-$GLIBC.apk \
  && ln -s /lib/libz.so.1 /usr/glibc-compat/lib \
  && ln -s /lib/libc.musl-x86_64.so.1 /usr/glibc-compat/lib \
  && ln -s /usr/lib/libgcc_s.so.1 /usr/glibc-compat/lib
COPY --from=docker/compose:1.21.0 /usr/local/bin/docker-compose /bin/docker-compose
