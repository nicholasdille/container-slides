#!/bin/bash
set -o errexit

#function cleanup() {
#    docker compose down
#}
#trap cleanup EXIT

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

#echo "Setting root password"
#docker compose exec gitlab gitlab-rails runner -e production "user = User.find_by_username('root'); user.password = '${SEAT_PASS}'; user.password_confirmation = '${SEAT_PASS}'; user.save!"

echo "Creating PAT for root"
ROOT_TOKEN="$(openssl rand -hex 32)"
if ! docker compose exec gitlab curl http://localhost/api/v4/user \
        --silent \
        --fail \
        --output /dev/null \
        --header "Private-Token: ${ROOT_TOKEN}"; then
    docker compose exec gitlab gitlab-rails runner -e production "user = User.find_by_username('root'); token = user.personal_access_tokens.create(scopes: [:api, :read_api, :read_user, :read_repository, :write_repository, :sudo], name: 'almighty'); token.set_token('${ROOT_TOKEN}'); token.save!"
fi

echo "Creating user seat"
#if ! docker compose exec gitlab gitlab-rails runner -e production "user=User.find_by_username('seat')"; then
#    docker compose exec gitlab gitlab-rails runner -e production "u = User.new(username: 'seat', email: 'seat@${DOMAIN}', name: 'Seat User', password: '${SEAT_PASS}', password_confirmation: '${SEAT_PASS}'); u.skip_confirmation!; u.save!; user = User.find_by_username('seat'); user.skip_reconfirmation!"
#fi
if ! docker compose exec gitlab curl http://localhost/api/v4/users \
        --silent \
        --fail \
        --header "Private-Token: ${ROOT_TOKEN}" \
     | jq --exit-status '.[] | select(.username == "seat")' >/dev/null; then
    docker compose exec gitlab curl http://localhost/api/v4/users \
        --silent \
        --fail \
        --header "Private-Token: ${ROOT_TOKEN}" \
        --header "Content-Type: application/json" \
        --request POST \
        --data "{\"username\": \"seat\", \"name\": \"seat\", \"email\": \"seat@${DOMAIN}\", \"password\": \"${SEAT_PASS}\", \"skip_confirmation\": \"true\", \"admin\": \"true\"}"
EOF
fi

#echo "Creating PAT for seat"
### RAILS
#if ! docker compose exec gitlab curl -sfo /dev/null -H "Private-Token: ${SEAT_PASS}" http://localhost/api/v4/user; then
#    docker compose exec gitlab gitlab-rails runner -e production "user = User.find_by_username('seat'); token = user.personal_access_tokens.create(scopes: [:api, :read_api, :read_user, :read_repository, :write_repository, :sudo], name: 'almighty'); token.set_token('${SEAT_PASS}'); token.save!"
#fi
### API
#USER_ID="$(
#    docker compose exec gitlab curl http://localhost/api/v4/users \
#        --silent \
#        --fail \
#        --header "Private-Token: ${ROOT_TOKEN}" \
#    | jq '.[] | select(.username == "seat") | .id'
#)"
#if test -z "${USER_ID}"; then
#    echo "ERROR: Failed to retrieve user ID."
#    exit 1
#fi
#TOKEN_NAME="$(openssl rand -hex 8)"
#EXPIRES_AT="$(date -d "next week" +%Y%m%d)"
#docker compose exec gitlab curl "http://localhost/api/v4/users/${USER_ID}/personal_access_tokens" \
#    --silent --verbose \
#    --fail \
#    --header "Private-Token: ${ROOT_TOKEN}" \
#    --header "Content-Type: application/json" \
#    --request POST \
#    --data "{\"name\": \"${TOKEN_NAME}\", \"expires_at\": \"${EXPIRES_AT}\", \"scopes\": [ \"api\" ] }"

echo "Retrieve runner registration token"
export REGISTRATION_TOKEN="$(docker compose exec gitlab gitlab-rails runner -e production "puts Gitlab::CurrentSettings.current_application_settings.runners_registration_token")"
docker compose build --pull runner
docker compose up -d runner
