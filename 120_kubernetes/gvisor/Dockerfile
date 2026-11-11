FROM ghcr.io/uniget-org/tools/gvisor:main AS gvisor

FROM kindest/node:v1.37.0
COPY --from=gvisor / /