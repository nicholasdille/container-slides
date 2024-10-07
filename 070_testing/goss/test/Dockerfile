FROM aelsabbahy/goss:v0.3.9 AS goss

FROM nginx:1.27.2
COPY --from=goss /goss/goss /goss
COPY goss.yaml /
