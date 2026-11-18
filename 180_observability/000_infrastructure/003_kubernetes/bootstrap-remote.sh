#!/bin/bash
set -o errexit -o pipefail

source .env

# Make sure inotify limits are sufficient for monitoring components
sysctl -w fs.inotify.max_user_instances=8192
sysctl -w fs.inotify.max_user_watches=524288

# Deploy kubernetes cluster
kind delete cluster
kind delete cluster --name seat${SEAT_INDEX}
kind create cluster --name seat${SEAT_INDEX} --config=kind.yaml
