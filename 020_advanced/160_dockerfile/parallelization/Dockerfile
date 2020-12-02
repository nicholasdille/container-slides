FROM docker:stable AS base
RUN apk add --update-cache --no-cache \
        git \
        curl \
        ca-certificates \
        openssl \
        jq \
        gettext \
        apache2-utils \
        bash \
        bind-tools

FROM base AS kubectl
RUN curl --silent https://storage.googleapis.com/kubernetes-release/release/stable.txt | \
        xargs -I{} curl -sLo /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/{}/bin/linux/amd64/kubectl \
 && chmod +x /usr/local/bin/kubectl

FROM base AS helm
# renovate: datasource=github-releases depName=helm/helm
ENV HELM_VERSION=v3.4.1
RUN curl --silent --location "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz" | \
        tar -xvzC /usr/local/bin/ --strip-components=1 linux-amd64/helm

FROM base AS trivy
# renovate: datasource=github-releases depName=aquasecurity/trivy
ENV TRIVY_VERSION=v0.12.0
RUN curl --silent --location --fail https://github.com/aquasecurity/trivy/releases/download/${TRIVY_VERSION}/trivy_${TRIVY_VERSION:1}_Linux-64bit.tar.gz | \
        tar -xvzC /usr/local/bin/ trivy

FROM base AS yq
# renovate: datasource=github-releases depName=mikefarah/yq
ENV YQ_VERSION=3.4.1
RUN curl --silent --location --fail --output /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64 \
 && chmod +x /usr/local/bin/yq

FROM base AS final
COPY --from=kubectl /usr/local/bin/kubectl /usr/local/bin/
COPY --from=helm /usr/local/bin/helm /usr/local/bin/
COPY --from=trivy /usr/local/bin/trivy /usr/local/bin/
COPY --from=yq /usr/local/bin/yq /usr/local/bin/
