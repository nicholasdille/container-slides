FROM ghcr.io/uniget-org/tools/gvisor:main AS gvisor

FROM kindest/node:v1.35.0
COPY --from=gvisor / /