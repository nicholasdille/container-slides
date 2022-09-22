#!/bin/bash
set -o errexit

if test -f .env; then
    source .env
fi

export REGISTRATION_TOKEN="foo"

docker compose pull traefik gitlab
docker compose up -d traefik gitlab

GITLAB_MAX_WAIT=300
SECONDS=0
while ! docker compose exec --no-tty gitlab curl -sfo /dev/null http://localhost/-/readiness?all=1; do
    if test "${SECONDS}" -gt "${GITLAB_MAX_WAIT}"; then
        echo "ERROR: Timeout waiting for GitLab to become ready."
        exit 1
    fi

    echo "Waiting for GitLab to become ready..."
    sleep 10
done
echo "GitLab ready after ${SECONDS} second(s)"

echo "Creating PAT for root"
ROOT_TOKEN="$(openssl rand -hex 32)"
if ! docker compose exec --no-tty gitlab curl http://localhost/api/v4/user \
        --silent \
        --fail \
        --output /dev/null \
        --header "Private-Token: ${ROOT_TOKEN}"; then
    docker compose exec --no-tty gitlab gitlab-rails runner -e production "user = User.find_by_username('root'); token = user.personal_access_tokens.create(scopes: [:api, :read_api, :read_user, :read_repository, :write_repository, :sudo], name: 'almighty'); token.set_token('${ROOT_TOKEN}'); token.save!"
fi

echo "Creating user seat"
if ! docker compose exec --no-tty gitlab curl http://localhost/api/v4/users \
        --silent \
        --fail \
        --header "Private-Token: ${ROOT_TOKEN}" \
     | jq --exit-status '.[] | select(.username == "seat")' >/dev/null; then
    docker compose exec --no-tty gitlab curl http://localhost/api/v4/users \
        --silent \
        --fail \
        --header "Private-Token: ${ROOT_TOKEN}" \
        --header "Content-Type: application/json" \
        --request POST \
        --data "{\"username\": \"seat\", \"name\": \"seat\", \"email\": \"seat@${DOMAIN}\", \"password\": \"${SEAT_PASS}\", \"skip_confirmation\": \"true\", \"admin\": \"true\"}"
EOF
fi

echo "Retrieve runner registration token"
export REGISTRATION_TOKEN="$(docker compose exec --no-tty gitlab gitlab-rails runner -e production "puts Gitlab::CurrentSettings.current_application_settings.runners_registration_token")"
docker compose build --pull runner
docker compose up -d runner
