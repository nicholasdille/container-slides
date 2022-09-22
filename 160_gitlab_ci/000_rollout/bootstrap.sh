#!/bin/bash
set -o errexit

if test "$(dirname "$0")" != "${PWD}"; then
    pushd "$(dirname "$0")"
fi

source /etc/profile.d/ip.sh
source /etc/profile.d/domain.sh
source /etc/profile.d/seat_index.sh
source /etc/profile.d/seat_pass.sh
source /etc/profile.d/seat_htpasswd.sh
source /etc/profile.d/seat_htpasswd_only.sh
if test -f .env; then
    source .env
fi

echo
echo "### Removing previous deployment"
docker compose down --volumes

echo
echo "### Pulling images"
docker compose pull traefik gitlab
docker compose up -d traefik gitlab

echo
echo "### Waiting for GitLab to be available"
docker compose exec -T gitlab \
    timeout 300 \
        curl http://localhost/-/readiness?all=1 \
            --silent \
            --fail \
            --output /dev/null

echo
echo "### Creating PAT for root"
ROOT_TOKEN="$(openssl rand -hex 32)"
docker compose exec -T gitlab gitlab-rails runner -e production "user = User.find_by_username('root'); token = user.personal_access_tokens.create(scopes: [:api, :read_api, :read_user, :read_repository, :write_repository, :sudo], name: 'almighty'); token.set_token('${ROOT_TOKEN}'); token.save!"

echo
echo "### Creating user seat"
docker compose exec -T gitlab \
    curl http://localhost/api/v4/users \
        --silent \
        --fail \
        --header "Private-Token: ${ROOT_TOKEN}" \
        --header "Content-Type: application/json" \
        --request POST \
        --data "{\"username\": \"seat\", \"name\": \"seat\", \"email\": \"seat@${DOMAIN}\", \"password\": \"${SEAT_PASS}\", \"skip_confirmation\": \"true\", \"admin\": \"true\"}"

echo
echo "### Retrieving runner registration token"
export REGISTRATION_TOKEN="$(docker compose exec -T gitlab gitlab-rails runner -e production "puts Gitlab::CurrentSettings.current_application_settings.runners_registration_token")"

echo
echo "### Starting runner"
docker compose build --pull runner
docker compose up -d runner
