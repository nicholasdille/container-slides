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

TRAEFIK_HTPASSWD="$( htpasswd -nbB admin "${GITLAB_ADMIN_PASS}" )"
export TRAEFIK_HTPASSWD

for SEAT_INDEX in $( jq --raw-output '.seats[].index' seats.json ); do
    export SEAT_INDEX

    docker compose --file compose.yaml --file compose.vscode.yaml --env-file vscode.env exec vscode${SEAT_INDEX} git -C /home/seat/demo checkout main
    docker compose --file compose.yaml --file compose.vscode.yaml --env-file vscode.env exec vscode${SEAT_INDEX} git -C /home/seat/demo branch --set-upstream-to=origin/main main
    break
done
