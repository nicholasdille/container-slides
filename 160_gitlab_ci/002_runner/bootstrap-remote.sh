#!/bin/bash
set -o errexit -o pipefail

# Check for seats.json
if ! test -f seats.json; then
    echo "ERROR: Missing seats.json"
    exit 1
fi

# Get variables
DOMAIN="$( jq --raw-output '.domain' seats.json )"
GITLAB_ADMIN_TOKEN="$( jq --raw-output '.gitlab_admin_token' seats.json )"
export DOMAIN
export GITLAB_ADMIN_TOKEN

CI_SERVER_TOKEN="$(cat runner_token.json)"
export CI_SERVER_TOKEN

echo
echo "### Starting runner"
docker compose build runner
docker compose up -d runner
