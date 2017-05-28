FROM alpine:3.5

MAINTAINER Maestrano <it@maestrano.com>

ENV GOPATH /go
ENV PATH $PATH:$GOPATH/bin
ENV CGO_ENABLED 0

WORKDIR /go/src/github.com/minio/

RUN  \
     apk add --no-cache ca-certificates curl && \
     apk add --no-cache --virtual .build-deps git go musl-dev && \
     echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf && \
     go get -v -d github.com/minio/minio && \
     cd /go/src/github.com/minio/minio && \
     go install -v -ldflags "$(go run buildscripts/gen-ldflags.go)" && \
     rm -rf /go/pkg /go/src /usr/local/go && apk del .build-deps

EXPOSE 9000

# Entrypoint
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

# Healthcheck
COPY healthcheck.sh /usr/local/bin/
HEALTHCHECK --timeout=5s CMD sh /usr/local/bin/healthcheck.sh

# Data (/export) and configuration (/root/.minio) volumes
VOLUME ["/export","/root/.minio"]

# Start in server mode by default
CMD ["server","/export"]
