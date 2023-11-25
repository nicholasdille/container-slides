#syntax=docker/dockerfile:1.6.0

FROM codercom/code-server:4.18.0
USER root

RUN <<EOF
code-server --install-extension redhat.vscode-yaml
code-server --install-extension golang.go
code-server --install-extension gitlab.gitlab-workflow
EOF

RUN <<EOF
apt-get update
apt-get -y install --no-install-recommends \
    curl \
    ca-certificates \
    git \
    tzdata \
    unzip \
    ncurses-bin \
    time \
    less \
    bash-completion \
    gettext-base \
    vim-tiny
EOF

RUN <<EOF
curl -sLf https://github.com/uniget-org/cli/releases/latest/download/uniget_linux_$(uname -m).tar.gz \
| sudo tar -xzC /usr/local/bin uniget
uniget install \
    gojq \
    go \
    glab
EOF

# See https://github.com/coder/code-server/issues/5177
ENV ENTRYPOINTD=/opt/entrypoint.d
RUN <<EOF
mkdir -p "${ENTRYPOINTD}"
EOF
COPY --chmod=0755 git.sh ${ENTRYPOINTD}
COPY --chmod=0755 repository.sh ${ENTRYPOINTD}

RUN <<EOF
useradd --user-group --create-home --shell /bin/bash seat
EOF
USER seat
WORKDIR /home/seat