FROM alpine:3.7

ENV TIME_SERVER=pool.ntp.org

RUN apk update \
 && apk add openntpd gettext

ADD files /
ENTRYPOINT [ "ntpd", "-d" ]