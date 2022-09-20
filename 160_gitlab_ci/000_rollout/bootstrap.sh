#!/bin/bash
set -o errexit

#function cleanup() {
#    docker compose down
#}
#trap cleanup EXIT

# TODO: Use .env
export REGISTRATION_TOKEN="foo"
export SEAT_INDEX=0
#export DOMAIN="seat${SEAT_INDEX}.inmylab.de"
export DOMAIN="127.0.0.1.nip.io"
export SEAT_PASS="foobarblarg"
export SEAT_HTPASSWD="baz"
export SEAT_HTPASSWD_ONLY=""

docker compose pull traefik gitlab
docker compose up -d traefik gitlab

GITLAB_MAX_WAIT=180
SECONDS=0
while ! docker compose exec gitlab curl -sfo /dev/null http://localhost/-/readiness?all=1; do
    if test "${SECONDS}" -gt "${GITLAB_MAX_WAIT}"; then
        echo "ERROR: Timeout waiting for GitLab to become ready."
        exit 1
    fi

    echo "Waiting for GitLab to become ready..."
    sleep 10
done
echo "GitLab ready"

#echo "Setting root password"
#docker compose exec gitlab gitlab-rails runner -e production "user = User.find_by_username('root'); user.password = '${SEAT_PASS}'; user.password_confirmation = '${SEAT_PASS}'; user.save!"

echo "Creating PAT for root"
if ! docker compose exec gitlab curl -sfo /dev/null -H "Private-Token: ${SEAT_PASS}" http://localhost/api/v4/user; then
    docker compose exec gitlab gitlab-rails runner -e production "user = User.find_by_username('root'); token = user.personal_access_tokens.create(scopes: [:api, :read_api, :read_user, :read_repository, :write_repository, :sudo], name: 'foo'); token.set_token('${SEAT_PASS}'); token.save!"
fi

echo "Retrieve runner registration token"
export REGISTRATION_TOKEN="$(docker compose exec gitlab gitlab-rails runner -e production "puts Gitlab::CurrentSettings.current_application_settings.runners_registration_token")"
docker compose build --pull runner
docker compose up -d runner
