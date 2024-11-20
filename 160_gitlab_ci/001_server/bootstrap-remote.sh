#!/bin/bash
set -o errexit -o pipefail

# Check for seats.json
if ! test -f seats.json; then
    echo "ERROR: Missing seats.json"
    exit 1
fi

# Fix certificate
cat /etc/ssl/tls.crt /etc/ssl/tls.chain >/etc/ssl/tls.full

# Get variables
DOMAIN="$( jq --raw-output '.domain' seats.json )"
GITLAB_ADMIN_PASS="$( jq --raw-output '.gitlab_admin_password' seats.json )"
export DOMAIN
export GITLAB_ADMIN_PASS

# Start GitLab
docker compose --file compose.yaml up -d

# Wait for GitLab to become available
GITLAB_MAX_WAIT=600
SECONDS=0
while ! docker compose exec -T gitlab \
        curl \
            --silent \
            --fail \
            --output /dev/null \
            http://localhost/-/readiness?all=1; do
    if test "${SECONDS}" -gt "${GITLAB_MAX_WAIT}"; then
        echo "ERROR: Timeout waiting for GitLab to become ready."
        exit 1
    fi

    echo "Waiting for GitLab to become ready..."
    sleep 10
done
echo "GitLab ready after ${SECONDS} second(s)"

# Set root token
GITLAB_ADMIN_TOKEN="$( jq --raw-output '.gitlab_admin_token' seats.json )"
export GITLAB_ADMIN_TOKEN
echo
echo "### PAT for root"
if ! docker compose exec -T gitlab \
        curl \
            --url http://localhost/api/v4/user \
            --silent \
            --fail \
            --output /dev/null \
            --header "Private-Token: ${GITLAB_ADMIN_TOKEN}"; then
    echo -n "    Creating..."
    docker compose exec -T gitlab \
        gitlab-rails runner -e production "user = User.find_by_username('root'); token = user.personal_access_tokens.create(scopes: [:api, :read_api, :read_user, :read_repository, :write_repository, :sudo], name: 'almighty', expires_at: 365.days.from_now); token.set_token('${GITLAB_ADMIN_TOKEN}'); token.save!"
    echo "done."
fi

# nginx
echo -n >seats.env
for SEAT_INDEX in $(jq --raw-output '.seats[].index' seats.json); do

    SEAT_CODE="$( jq --raw-output --arg index "${SEAT_INDEX}" '.seats[] | select(.index == $index) | .code' seats.json )"
    VAR_NAME="SEAT${SEAT_INDEX}_CODE_HTPASSWD"
    declare -n $VAR_NAME=SEAT_CODE_HTPASSWD
    SEAT_CODE_HTPASSWD="$( htpasswd -nbB "seat${SEAT_INDEX}" "${SEAT_CODE}" | sed -e 's/\$/\$/g' )"
    echo "${VAR_NAME}='${!VAR_NAME}'" >>seats.env

    SEAT_PASS="$( jq --raw-output --arg index "${SEAT_INDEX}" '.seats[] | select(.index == $index) | .password' seats.json )"
    VAR_NAME="SEAT${SEAT_INDEX}_PASS"
    declare -n $VAR_NAME=SEAT_PASS
    SEAT_PASS="${!VAR_NAME}"
    echo "${VAR_NAME}='${!VAR_NAME}'" >>seats.env

    SEAT_WEBDAV_DEV="$( jq --raw-output --arg index "${SEAT_INDEX}" '.seats[] | select(.index == $index) | .webdav_pass_dev' seats.json )"
    VAR_NAME="SEAT${SEAT_INDEX}_WEBDAV_DEV"
    declare -n $VAR_NAME=SEAT_WEBDAV_DEV
    SEAT_WEBDAV_DEV="${!VAR_NAME}"
    echo "${VAR_NAME}='${!VAR_NAME}'" >>seats.env

    SEAT_WEBDAV_LIVE="$( jq --raw-output --arg index "${SEAT_INDEX}" '.seats[] | select(.index == $index) | .webdav_pass_live' seats.json )"
    VAR_NAME="SEAT${SEAT_INDEX}_WEBDAV_LIVE"
    declare -n $VAR_NAME=SEAT_WEBDAV_LIVE
    SEAT_WEBDAV_LIVE="${!VAR_NAME}"
    echo "${VAR_NAME}='${!VAR_NAME}'" >>seats.env
done

# TODO: Pass SEAT_COUNT
docker compose --file compose.yaml --file compose.nginx.yaml --env-file seats.env up --build --detach nginx