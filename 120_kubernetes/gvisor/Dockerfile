FROM ghcr.io/uniget-org/tools/gvisor:main AS gvisor

FROM kindest/node:v1.31.1
COPY --from=gvisor / /