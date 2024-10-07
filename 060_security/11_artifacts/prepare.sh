#!/bin/bash
set -o errexit

uniget install trivy regclient cosign notation oras

trivy plugin install github.com/aquasecurity/trivy-plugin-referrer
