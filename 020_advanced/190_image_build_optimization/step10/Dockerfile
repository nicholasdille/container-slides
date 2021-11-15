# syntax=docker/dockerfile:1.3-labs

FROM golang:1.17 AS build
WORKDIR /go/src/gitlab.com/nicholasdille/cc21_container_image_build_optimization
COPY go.* .
RUN go mod download
COPY . .
RUN go build -o hello .
RUN cp hello /

FROM ubuntu:20.04 AS step4
COPY --from=build /hello /usr/local/bin/
RUN --mount=type=cache,target=/var/lib/apt/lists \
    --mount=type=cache,target=/var/cache \
    --mount=type=cache,target=/var/log \
    <<EOF
apt-get update
apt-get -y install --no-install-recommends \
    curl \
    ca-certificates \
    jq
EOF
USER nobody