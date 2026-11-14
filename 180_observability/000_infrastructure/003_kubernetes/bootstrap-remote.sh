#!/bin/bash
set -o errexit -o pipefail

# Make sure inotify limits are sufficient for monitoring components
sysctl -w fs.inotify.max_user_instances=8192
sysctl -w fs.inotify.max_user_watches=524288

# Deploy kubernetes cluster
kind delete cluster
kind create cluster --config=kind.yaml
