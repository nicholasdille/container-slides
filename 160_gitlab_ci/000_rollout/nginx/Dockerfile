FROM nginx:1.22.1

RUN apt-get update \
 && apt-get -y install \
        nginx-extras \
        apache2-utils \
        procps \
        vim-tiny

RUN rm -f /etc/nginx/sites-enabled/* \
 && mkdir -p \
        /data.dev \
        /data.live \
        /etc/nginx/auth \
 && chown www-data \
        /data.dev \
        /data.live

#COPY default.conf /etc/nginx/conf.d/
COPY webdav.conf /etc/nginx/conf.d/
COPY --chmod=0775 webdav.sh /docker-entrypoint.d/
COPY --chmod=0775 seat-index.sh /docker-entrypoint.d/
COPY --chmod=0775 seat-pass.sh /docker-entrypoint.d/
COPY --chmod=0775 domain.sh /docker-entrypoint.d/

COPY index.html /usr/share/nginx/html/
COPY auth.html /usr/share/nginx/html/auth/index.html
