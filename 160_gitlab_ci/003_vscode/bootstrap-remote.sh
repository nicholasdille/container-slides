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
GITLAB_ADMIN_PASS="$( jq --raw-output '.gitlab_admin_password' seats.json )"
export DOMAIN

TRAEFIK_HTPASSWD="$( htpasswd -nbB admin "${GITLAB_ADMIN_PASS}" )"
export TRAEFIK_HTPASSWD

echo "services:" >compose.vscode.yaml
echo -n >vscode.env
for SEAT_INDEX in $( jq --raw-output '.seats[].index' seats.json ); do
    SEAT_PASS="$( jq --raw-output --arg index "${SEAT_INDEX}" '.[$index | tonumber]' personal_access_tokens.json )"
    export SEAT_INDEX
    export SEAT_PASS

    SEAT_HTPASSWD="$( htpasswd -nbB "seat${SEAT_INDEX}" "${SEAT_PASS}" )"
    echo "SEAT${SEAT_INDEX}_HTPASSWD='${SEAT_HTPASSWD}'" >>vscode.env

    export GIT_USER="seat${SEAT_INDEX}"
    export GIT_EMAIL="seat${SEAT_INDEX}@${DOMAIN}"
    export GIT_CRED="https://seat${SEAT_INDEX}:${SEAT_PASS}@gitlab.${DOMAIN}"

    cat compose.vscode.yaml.template \
    | envsubst '$SEAT_INDEX,$SEAT_PASS,$GIT_USER,$GIT_EMAIL,$GIT_CRED' \
    >>compose.vscode.yaml
done

docker build --tag vscode vscode
docker compose --file compose.yaml --file compose.vscode.yaml --env-file vscode.env up --detach
