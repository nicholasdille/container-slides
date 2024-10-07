FROM ghcr.io/nicholasdille/docker-setup/gvisor:main AS gvisor

FROM kindest/node:v1.31.0
COPY --from=gvisor / /