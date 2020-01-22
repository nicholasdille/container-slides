#!/bin/bash

export DOCKER_CLI_EXPERIMENTAL=enabled
if docker buildx inspect mybuilder; then
    docker buildx use default
    docker buildx rm mybuilder
fi
