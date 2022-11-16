# syntax=docker/dockerfile:1.4.3

FROM golang:1.18 AS build
WORKDIR /go/src/gitlab.com/nicholasdille/cc22_container_image_build_optimization
COPY go.* .
RUN go mod download
COPY . .
RUN go build -o hello .
RUN cp hello /

FROM ubuntu:22.04 AS step4
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