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

# Fix certificate
cat /etc/ssl/tls.crt /etc/ssl/tls.chain >/etc/ssl/tls.full

# Get variables
DOMAIN="$( jq --raw-output '.domain' seats.json )"
export DOMAIN

docker build --tag vscode vscode

echo "services:" >compose.vscode.yaml
for SEAT_INDEX in $( jq --raw-output '.seats[].index' seats.json ); do
    echo "seat${SEAT_INDEX}"
    SEAT_PASS="$( jq --raw-output --arg index "${SEAT_INDEX}" '.seats[] | select(.index == $index) | .password' seats.json )"
    export SEAT_INDEX
    export SEAT_PASS

    export GIT_USER="seat${SEAT_INDEX}"
    export GIT_EMAIL="seat${SEAT_INDEX}@.${DOMAIN}"
    export GIT_CRED="https://seat${SEAT_INDEX}:${SEAT_PASS}@gitlab.${DOMAIN}"

    cat compose.vscode.yaml.template \
    | envsubst '$SEAT_INDEX,$SEAT_PASS,$GIT_USER,$GIT_EMAIL,$GIT_CRED' \
    >>compose.vscode.yaml
done

docker compose --file compose.yaml --file compose.vscode.yaml up --detach