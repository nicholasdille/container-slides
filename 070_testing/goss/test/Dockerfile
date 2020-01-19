FROM aelsabbahy/goss:v0.3.9 AS goss

FROM nginx
COPY --from=goss /goss/goss /goss
COPY goss.yaml /
