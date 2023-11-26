#!/bin/bash
set -o errexit -o pipefail

# Check for seats.json
if ! test -f seats.json; then
    if test -f ../seats.json; then
        cp ../seats.json .
    else
        echo "ERROR: Missing seats.json"
        exit 1
    fi
fi

# Get variables
DOMAIN="$( jq --raw-output '.domain' seats.json )"
GITLAB_ADMIN_PASS="$( jq --raw-output '.gitlab_admin_password' seats.json )"
export DOMAIN
export GITLAB_ADMIN_PASS

echo
echo "### Retrieving runner registration token on seat ${SEAT_INDEX}"
if test -z "${CI_SERVER_TOKEN}"; then
    CI_SERVER_TOKEN="$(
        curl \
            --url "https://gitlab.${DOMAIN}/api/v4/user/runners" \
            --silent \
            --show-error \
            --request POST \
            --header "Private-Token: ${GITLAB_ADMIN_PASS}" \
            --header "Content-Type: application/json" \
            --data '{"runner_type": "instance_type", "run_untagged": true}' \
        | jq --raw-output '.token'
    )"
    export CI_SERVER_TOKEN
fi
echo "  Got ${CI_SERVER_TOKEN}."

echo
echo "### Starting runner on seat ${SEAT_INDEX}"
docker compose build runner
docker compose --project-directory ../server --file compose.yaml --file ../runner/compose.yaml up -d runner
