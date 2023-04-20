#!/bin/bash
set -o errexit

docker-setup --tools=trivy,regclient,cosign,notation,oras install

trivy plugin install github.com/aquasecurity/trivy-plugin-referrer
