FROM ghcr.io/uniget-org/tools/gvisor:main AS gvisor

FROM kindest/node:v1.32.0
COPY --from=gvisor / /