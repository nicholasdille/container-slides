FROM codercom/code-server:4.11.0
USER root

RUN code-server --install-extension redhat.vscode-yaml \
 && code-server --install-extension golang.go \
 && code-server --install-extension ms-azuretools.vscode-docker \
 && code-server --install-extension gitlab.gitlab-workflow

RUN apt-get update \
 && apt-get -y install --no-install-recommends \
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

RUN curl https://github.com/nicholasdille/docker-setup/raw/main/docker-setup \
        --silent \
        --location \
        --output /usr/local/bin/docker-setup \
 && chmod +x /usr/local/bin/docker-setup
# Workaround for https://github.com/nicholasdille/docker-setup/issues/5502
RUN docker-setup --tools=containerd install \
 && docker-setup --default install

ARG USER
ARG EMAIL
ARG GIT_CRED
RUN git config --global user.name "${USER}" \
 && git config --global user.email "${EMAIL}" \
 && git config --global credential.helper store \
 && echo "${GIT_CRED}" >"${HOME}/.git-credentials"

USER coder