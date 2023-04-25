#!/bin/bash
set -o errexit

docker-setup --tools=docker,buildx,docker-compose,kind,helm,kubectl,cilium install

kind create cluster --config kind.yaml
#XXX