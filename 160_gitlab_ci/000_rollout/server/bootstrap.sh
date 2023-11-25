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

# Start GitLab
docker compose --file compose.yaml up -d

# Wait for GitLab to become available
GITLAB_MAX_WAIT=300
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

# Disable sign-up
echo
echo "### Disabling sign-up on seat ${SEAT_INDEX}"
docker compose exec -T gitlab \
    curl \
        --url http://localhost/api/v4/application/settings?signup_enabled=false \
        --silent \
        --fail \
        --header "Private-Token: ${GITLAB_ADMIN_TOKEN}" \
        --header "Content-Type: application/json" \
        --request PUT \
        --output /dev/null

# Create users
for SEAT_INDEX in $(jq --raw-output '.seats[].index' seats.json); do
    echo
    echo "### User seat${SEAT_INDEX}"
    SEAT_PASS="$( jq --raw-output --arg index "${SEAT_INDEX}" '.seats[] | select(.index == $index) | .password' seats.json )"
    export SEAT_INDEX
    export SEAT_PASS
    if ! docker compose exec -T gitlab \
            curl \
                --url "http://localhost/api/v4/users?per_page=100" \
                --silent \
                --fail \
                --header "Private-Token: ${GITLAB_ADMIN_TOKEN}" \
            | jq --exit-status --arg user "seat${SEAT_INDEX}" '.[] | select(.username == $user)' >/dev/null; then
        echo -n "    Creating user..."
        docker compose exec -T gitlab \
            curl http://localhost/api/v4/users \
                --silent \
                --show-error \
                --fail \
                --header "Private-Token: ${GITLAB_ADMIN_TOKEN}" \
                --header "Content-Type: application/json" \
                --request POST \
                --data "{\"username\": \"seat${SEAT_INDEX}\", \"name\": \"seat${SEAT_INDEX}\", \"email\": \"seat${SEAT_INDEX}@${DOMAIN}\", \"password\": \"${SEAT_PASS}\", \"skip_confirmation\": \"true\"}"
        echo "done."
    fi

    echo
    echo "### PAT for user seat${SEAT_INDEX}"
    SEAT_GITLAB_TOKEN="$( jq --raw-output --arg index "${SEAT_INDEX}" '.seats[] | select(.index == $index) | .gitlab_token' seats.json )"
    export SEAT_GITLAB_TOKEN
    if ! docker compose exec -T gitlab \
            curl \
                --url http://localhost/api/v4/user \
                --silent \
                --fail \
                --output /dev/null \
                --header "Private-Token: ${SEAT_GITLAB_TOKEN}"; then
        echo -n "    Creating PAT..."
        docker compose exec -T gitlab \
            gitlab-rails runner -e production "user = User.find_by_username('seat${SEAT_INDEX}'); token = user.personal_access_tokens.create(scopes: [:api, :read_api, :read_user, :read_repository, :write_repository], name: 'demo', expires_at: 30.days.from_now); token.set_token('${SEAT_GITLAB_TOKEN}'); token.save!"
        echo "done."
    fi

    echo
    echo "### Fetching user ID for seat on seat ${SEAT_INDEX}..."
    GITLAB_USER_ID="$(
        docker compose exec -T gitlab \
            curl \
                --url http://localhost/api/v4/user \
                --silent \
                --show-error \
                --fail \
                --header "Private-Token: ${SEAT_GITLAB_TOKEN}" \
        | jq --raw-output '.id'
    )"
    echo "    Got ${GITLAB_USER_ID}"
done

# - Create project for each user (import and create new default branch main)

# nginx
# - Create variables SEATx_CODE_HTPASSWD
# - Provide seats.json
