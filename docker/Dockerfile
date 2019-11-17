FROM nginx:stable-alpine

RUN apk add --update-cache --no-cache \
        curl \
        git \
        bash

ENV SOURCE=https://github.com/nicholasdille/Sessions
COPY default.conf /etc/nginx/conf.d/
COPY entrypoint.sh /
ENTRYPOINT /entrypoint.sh
