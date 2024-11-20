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

# Create users
for SEAT_INDEX in $(jq --raw-output '.seats[].index' seats.json); do
    echo
    echo "### User seat${SEAT_INDEX}"

    SEAT_GITLAB_TOKEN="$( jq --raw-output --arg index "${SEAT_INDEX}" '.seats[] | select(.index == $index) | .gitlab_token' seats.json )"
    export SEAT_GITLAB_TOKEN
    docker compose exec -T gitlab \
        curl \
            --url "http://localhost/api/v4/projects/seat${SEAT_INDEX}%2fdemo" \
            --silent \
            --show-error \
            --request PUT \
            --header "Private-Token: ${SEAT_GITLAB_TOKEN}" \
            --data 'default_branch=main'
done