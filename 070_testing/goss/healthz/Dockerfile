FROM aelsabbahy/goss:v0.3.16 as goss

FROM nginx:1.27.3

# Copy binaries
COPY --from=goss /goss /goss

# Add test definition
COPY goss.yaml /

# Configure init
RUN apt-get update && apt-get -y install supervisor
COPY supervisord.conf /etc/supervisor/
COPY *.conf /etc/supervisor/conf.d/
ENTRYPOINT [ "supervisord", "-c", "/etc/supervisor/supervisord.conf" ]
