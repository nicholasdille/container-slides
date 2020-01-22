# syntax = docker/dockerfile:1.1-experimental
FROM ubuntu
RUN --mount=type=cache,target=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt \
    apt-get update