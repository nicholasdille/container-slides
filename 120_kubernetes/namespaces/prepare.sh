#!/bin/bash
set -o errexit

uniget install docker buildx docker-compose kind kubectl

kind create cluster