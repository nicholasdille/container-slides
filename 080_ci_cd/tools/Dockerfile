FROM alpine

RUN apk update \
    && apk add ca-certificates curl wget unzip bash jq gettext

# kubectl
RUN RELEASE="$(curl --silent --location --show-error https://dl.k8s.io/release/stable.txt)" \
    && cd /usr/local/bin \
    && curl --location --remote-name-all https://storage.googleapis.com/kubernetes-release/release/${RELEASE}/bin/linux/amd64/kubectl \
    && chmod +x /usr/local/bin/kubectl

# drone
RUN curl --silent --location https://github.com/drone/drone-cli/releases/download/v0.8.6/drone_linux_amd64.tar.gz | tar -xvz -C /usr/local/bin/

# concourse fly
RUN curl --silent --location https://github.com/concourse/concourse/releases/download/v4.2.1/fly_linux_amd64 > /usr/local/bin/fly \
    && chmod +x /usr/local/bin/fly

# docker-ls
RUN wget https://github.com/mayflower/docker-ls/releases/download/v0.3.1/docker-ls-linux-amd64.zip \
    && unzip docker-ls-linux-amd64.zip \
    && mv docker-ls docker-rm /usr/local/bin/ \
    && rm docker-ls-linux-amd64.zip

# docker-compose
RUN curl --silent --location https://github.com/docker/compose/releases/download/1.22.0/docker-compose-Linux-x86_64 > /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose

# docker-machine
RUN curl --silent --location https://github.com/docker/machine/releases/download/v0.15.0/docker-machine-Linux-x86_64 > /usr/local/bin/docker-machine \
    && chmod +x /usr/local/bin/docker-machine

# docker-app
RUN curl --silent --location https://github.com/docker/app/releases/download/v0.5.0/docker-app-linux.tar.gz | tar -xvz -C /usr/local/bin/ \
    && mv /usr/local/bin/docker-app-linux /usr/local/bin/docker-app

ARG CI_REPO_NAME
ARG CI_BUILD_NUMBER
LABEL ${CI_REPO_NAME}=${CI_BUILD_NUMBER}