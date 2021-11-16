# syntax=docker/dockerfile:1.3-labs

FROM golang:1.17 AS build
WORKDIR /go/src/gitlab.com/nicholasdille/cc21_container_image_build_optimization
COPY go.* .
RUN go mod download
COPY . .
RUN go build -o hello .
RUN cp hello /

FROM ubuntu:21.04 AS base
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

FROM base AS kubectl
ARG KUBECTL_VERSION=1.22.3
RUN <<EOF
curl -sLo /usr/local/bin/kubectl "https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
chmod +x /usr/local/bin/kubectl
EOF

FROM base AS helm
ARG HELM_VERSION=3.7.1
RUN <<EOF
curl -sL "https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz" \
    | tar -xzC /usr/local/bin/ --strip-components=1 --no-same-owner \
        linux-amd64/helm
EOF

FROM base
COPY --from=build /hello /usr/local/bin/
COPY --from=kubectl /usr/local/bin/kubectl /usr/local/bin/
COPY --from=helm    /usr/local/bin/helm    /usr/local/bin/
USER nobody