# syntax=docker/dockerfile:1.3-labs

# Vanilla
FROM golang:1.17 AS step1
WORKDIR /go/src/gitlab.com/nicholasdille/cc21_container_image_build_optimization
COPY . .
RUN go build -o /usr/local/bin/hello .

# Multi-stage
FROM golang:1.17 AS step2-build
WORKDIR /go/src/gitlab.com/nicholasdille/cc21_container_image_build_optimization
COPY . .
RUN go build -o hello .
RUN go mod download
RUN cp hello /

FROM ubuntu:20.04 AS step2
COPY --from=step2-build /hello /usr/local/bin/

# Order of commands
FROM golang:1.17 AS step3-build
WORKDIR /go/src/gitlab.com/nicholasdille/cc21_container_image_build_optimization
COPY go.* .
RUN go mod download
COPY . .
RUN go build -o hello .
RUN cp hello /

FROM ubuntu:20.04 AS step3
COPY --from=step3-build /hello /usr/local/bin/

# USER
FROM ubuntu:20.04 AS step4
COPY --from=step3-build /hello /usr/local/bin/
USER nobody

# apt with bloat
FROM ubuntu:20.04 AS step4
COPY --from=step3-build /hello /usr/local/bin/
RUN apt-get update \
 && apt-get -y install --no-install-recommends \
        curl \
        ca-certificates \
        jq
USER nobody

# cache
FROM ubuntu:20.04 AS step6
COPY --from=step3-build /hello /usr/local/bin/
RUN --mount=type=cache,target=/var/lib/apt/lists \
    --mount=type=cache,target=/var/cache \
    --mount=type=cache,target=/var/log \
    apt-get update \
 && apt-get -y install --no-install-recommends \
        curl \
        ca-certificates \
        jq
USER nobody

# heredocs
FROM ubuntu:20.04 AS step7
COPY --from=step3-build /hello /usr/local/bin/
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

# parallel
FROM ubuntu:21.04 AS step8-base
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

FROM step8-base AS step8-kubectl
ARG KUBECTL_VERSION=1.22.3
RUN <<EOF
curl -sLo /usr/local/bin/kubectl "https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
chmod +x /usr/local/bin/kubectl
EOF

FROM step8-base AS step8-helm
ARG HELM_VERSION=3.7.1
RUN <<EOF
curl -sL "https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz" \
    | tar -xzC /usr/local/bin/ --strip-components=1 --no-same-owner \
        linux-amd64/helm
EOF

FROM step8-base AS step8
COPY --from=step3-build /hello /usr/local/bin/
COPY --from=step8-kubectl /usr/local/bin/kubectl /usr/local/bin/
COPY --from=step8-helm    /usr/local/bin/helm    /usr/local/bin/
USER nobody

# RenovateBot
FROM step8-base AS base

FROM step8-base AS step9-kubectl
# renovate: datasource=github-releases depName=kubernetes/kubernetes
ARG KUBECTL_VERSION=1.22.3
RUN <<EOF
curl -sLo /usr/local/bin/kubectl "https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
chmod +x /usr/local/bin/kubectl
EOF

FROM step8-base AS step9-helm
# renovate: datasource=github-releases depName=helm/helm
ARG HELM_VERSION=3.7.1
RUN <<EOF
curl -sL "https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz" \
    | tar -xzC /usr/local/bin/ --strip-components=1 --no-same-owner \
        linux-amd64/helm
EOF

FROM step8-base AS step9
COPY --from=step3-build /hello /usr/local/bin/
COPY --from=step9-kubectl /usr/local/bin/kubectl /usr/local/bin/
COPY --from=step9-helm    /usr/local/bin/helm    /usr/local/bin/
USER nobody
