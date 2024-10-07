#!/bin/bash
set -o errexit

uniget install docker buildx docker-compose kind helm kubectl

kind create cluster --config kind.yaml