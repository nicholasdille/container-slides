FROM alpine

RUN apk add --update-cache --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ \
        bash \
        curl \
        shellinabox \
 && mkdir -p /usr/share/shellinabox \
 && curl --silent --location --fail https://raw.githubusercontent.com/shellinabox/shellinabox/v2.20/shellinabox/white-on-black.css > /usr/share/shellinabox/white-on-black.css

ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh

WORKDIR /usr/share/shellinabox
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "--disable-ssl", "--service", "/:LOGIN", "--css", "white-on-black.css" ]