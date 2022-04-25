FROM alpine:3.15

RUN apk add --update-cache --no-cache \
        bash \
        curl \
        ca-certificates \
        php8-fpm \
        php8-xml \
        php8-ldap \
        phpldapadmin \
        nginx

COPY www.conf /etc/php8/php-fpm.d/
COPY default.conf /etc/nginx/http.d/
COPY config.php /etc/phpldapadmin/
COPY --chmod=0755 entrypoint.sh /

RUN chown -R nobody.nobody /run /var/lib/nginx /var/log/nginx /usr/share/webapps

EXPOSE 8080
USER nobody
CMD /entrypoint.sh
