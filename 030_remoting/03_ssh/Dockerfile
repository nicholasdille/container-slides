ARG VERSION=stable-dind
FROM docker:${VERSION}

RUN apk --update --no-cache add \
        shadow \
        bash \
        supervisor \
        openssh \
        sudo \
 && mkdir -p /var/log/supervisor \
 && ln -sf /usr/local/bin/docker /usr/bin/docker \
 && groupadd --system docker \
 && useradd --create-home --shell /bin/bash --groups docker user \
 && echo "user:user" | chpasswd user \
 && usermod --unlock user \
 && echo "user ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/user

COPY files /
RUN chmod +x /docker-entrypoint.sh

EXPOSE 22
ENTRYPOINT /docker-entrypoint.sh