#syntax=docker/dockerfile:1.28.0

FROM codercom/code-server:4.145.2
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
curl -sLf https://gitlab.com/uniget-org/cli/-/releases/permalink/latest/downloads/uniget_Linux_$(uname -m).tar.gz \
| tar -xzC /usr/local/bin uniget
uniget install \
    jq \
    kubectl \
    helm \
    opencode \
    copilot \
    claude
EOF

USER coder
ARG INDEX
COPY --chown=coder:coder kubeconfig.k8s${INDEX} /home/coder/.kube/config
COPY --chown=coder:coder settings.json /home/coder/.local/share/code-server/User/
COPY --chown=coder:coder opencode.jsonc /home/coder/.config/opencode/
WORKDIR /home/coder

RUN <<EOF
git clone https://github.com/nicholasdille/container-slides
EOF

# https://open-vsx.org/
# code-server --install-extension <publisher>.<extension-name>
RUN <<EOF
code-server --install-extension redhat.vscode-yaml
code-server --install-extension editorConfig.editorConfig
EOF