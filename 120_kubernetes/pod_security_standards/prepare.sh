#!/bin/bash
set -o errexit

uniget install docker buildx docker-compose kind helm kubectl gvisor cosign

kind create cluster --config kind.yaml