#syntax=docker/dockerfile:1.12.0

FROM nginx:1.27.3

RUN <<EOF
apt-get update
apt-get -y install \
        nginx-extras \
        apache2-utils \
        procps \
        vim-tiny
EOF

RUN <<EOF
rm -f /etc/nginx/sites-enabled/*
mkdir -p \
    /data.dev \
    /data.live \
    /etc/nginx/auth
chown www-data \
    /data.dev \
    /data.live
EOF

COPY default.conf /etc/nginx/conf.d/
COPY --chmod=0755 00-index.sh /docker-entrypoint.d/
COPY --chmod=0755 10-code.sh /docker-entrypoint.d/
COPY --chmod=0755 20-webdav.sh /docker-entrypoint.d/

COPY code.html /tmp/
COPY webdav.conf /tmp/
COPY index.html /usr/share/nginx/html/
