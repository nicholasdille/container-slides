#!/bin/bash
set -o errexit

docker-setup --tools=docker,buildx,docker-compose,kind,kubectl install

kind create cluster --config kind.yaml