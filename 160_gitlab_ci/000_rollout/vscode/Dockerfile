#syntax=docker/dockerfile:1.5.2

FROM codercom/code-server:4.18.0
USER root

RUN <<EOF
code-server --install-extension redhat.vscode-yaml
code-server --install-extension golang.go
code-server --install-extension ms-azuretools.vscode-docker
code-server --install-extension gitlab.gitlab-workflow
EOF

RUN <<EOF
apt-get update
apt-get -y install --no-install-recommends \
    curl \
    ca-certificates \
    iptables \
    git \
    tzdata \
    unzip \
    ncurses-bin \
    asciinema \
    time \
    jq \
    less \
    bash-completion \
    gettext-base \
    vim-tiny
EOF

RUN <<EOF
curl -sLf https://github.com/uniget-org/cli/releases/latest/download/uniget_linux_$(uname -m).tar.gz \
| sudo tar -xzC /usr/local/bin uniget
uniget install --default
EOF

RUN <<EOF
useradd --user-group --create-home --shell /bin/bash --groups docker seat
EOF
USER seat
WORKDIR /home/seat

ARG GIT_USER
ARG GIT_EMAIL
ARG GIT_CRED
RUN <<EOF
git config --global user.name "${GIT_USER}"
git config --global user.email "${GIT_EMAIL}"
git config --global credential.helper store
echo "${GIT_CRED}" >.git-credentials
EOF