FROM ghcr.io/nicholasdille/docker-setup/gvisor:main AS gvisor

FROM kindest/node:v1.25.3
COPY --from=gvisor / /