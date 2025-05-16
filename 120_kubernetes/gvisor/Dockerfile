FROM ghcr.io/uniget-org/tools/gvisor:main AS gvisor

FROM kindest/node:v1.31.9
COPY --from=gvisor / /