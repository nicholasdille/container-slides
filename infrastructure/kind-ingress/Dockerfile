#syntax=docker/dockerfile:1.15.1

FROM alpine:3.21.2 AS cpk
# renovate: datasource=github-releases depName=kubernetes-sigs/cloud-provider-kind
ARG CPK_VERSION=0.6.0
RUN <<EOF
apk add --update-cache \
    curl
curl --silent --show-error --location --fail \
    "https://github.com/kubernetes-sigs/cloud-provider-kind/releases/download/v${CPK_VERSION}/cloud-provider-kind_${CPK_VERSION}_linux_amd64.tar.gz" \
| tar --extract --gzip --directory=/usr/local/bin \
    cloud-provider-kind
EOF

FROM docker:29.1.2-cli
COPY --from=cpk /usr/local/bin/cloud-provider-kind /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/cloud-provider-kind"]
