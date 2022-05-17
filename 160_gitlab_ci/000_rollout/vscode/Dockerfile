FROM codercom/code-server:4.3.0
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

ARG DOCKER_SETUP_VERSION=1.4.28
RUN curl https://github.com/nicholasdille/docker-setup/releases/download/v${DOCKER_SETUP_VERSION}/docker-setup.sh \
        --silent \
        --location \
        --output /usr/local/bin/docker-setup \
 && chmod +x /usr/local/bin/docker-setup

ARG docker_max_wait=60
RUN docker-setup --no-wait --skip-docs --only docker --debug || true

USER coder