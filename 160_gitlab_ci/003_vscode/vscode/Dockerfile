#syntax=docker/dockerfile:1.20.0

FROM codercom/code-server:4.109.2
USER root

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
    glab \
    gitlabci-local
EOF

COPY --chmod=0755 git.sh /entrypoint.d/

RUN <<EOF
useradd --user-group --create-home --shell /bin/bash seat
chown -R seat:seat /home/seat
EOF
USER seat
COPY --chown=seat:seat settings.json /home/seat/.local/share/code-server/User/
WORKDIR /home/seat/demo

# https://open-vsx.org/
# code-server --install-extension <publisher>.<extension-name>
RUN <<EOF
code-server --install-extension redhat.vscode-yaml
code-server --install-extension golang.go
code-server --install-extension gitlab.gitlab-workflow
code-server --install-extension editorConfig.editorConfig
EOF