#!/bin/bash
set -o errexit -o pipefail

# Check for seats.json
if ! test -f seats.json; then
    echo "ERROR: Missing seats.json"
    exit 1
fi

# Fetch runner token
CI_SERVER_TOKEN="$( cat runner_token.json )"
export CI_SERVER_TOKEN

echo
echo "### Starting runner"
docker compose \
    up \
        --detach \
        runner
