#!/bin/bash

export DOCKER_CLI_EXPERIMENTAL=enabled
docker buildx use default
docker buildx rm mybuilder
