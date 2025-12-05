#!/bin/bash

docker rm -f registry

if docker buildx inspect mybuilder; then
    docker buildx use default
    docker buildx rm mybuilder
fi
true
