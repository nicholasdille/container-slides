FROM nginx:1.20.2
COPY index.html /usr/share/nginx/html/
COPY --chmod=0755 content-entrypoint.sh /
ENTRYPOINT [ "/content-entrypoint.sh" ]