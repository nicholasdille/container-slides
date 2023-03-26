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
source /etc/profile.d/seat_code.sh
source /etc/profile.d/seat_code_htpasswd.sh
if test -f .env; then
    source .env
fi

#echo
#echo "### Removing previous deployment on seat ${SEAT_INDEX}"
#docker compose version
#docker compose down --volumes

echo
echo "### Pulling images on seat ${SEAT_INDEX}"
docker compose pull traefik gitlab
docker compose up -d traefik gitlab

echo
echo "### Waiting for GitLab to be available on seat ${SEAT_INDEX}"
export REGISTRATION_TOKEN=foo
GITLAB_MAX_WAIT=300
SECONDS=0
while ! docker compose exec -T gitlab \
        curl -sfo /dev/null http://localhost/-/readiness?all=1; do
    if test "${SECONDS}" -gt "${GITLAB_MAX_WAIT}"; then
        echo "ERROR: Timeout waiting for GitLab to become ready."
        exit 1
    fi

    echo "Waiting for GitLab to become ready..."
    sleep 10
done
echo "GitLab ready after ${SECONDS} second(s)"

echo
echo "### Creating PAT for root on seat ${SEAT_INDEX}"
ROOT_TOKEN="$(openssl rand -hex 32)"
if ! docker compose exec -T gitlab \
        curl http://localhost/api/v4/user \
            --silent \
            --fail \
            --output /dev/null \
            --header "Private-Token: ${ROOT_TOKEN}"; then
    docker compose exec -T gitlab \
        gitlab-rails runner -e production "user = User.find_by_username('root'); token = user.personal_access_tokens.create(scopes: [:api, :read_api, :read_user, :read_repository, :write_repository, :sudo], name: 'almighty'); token.set_token('${ROOT_TOKEN}'); token.save!"
fi

echo
echo "### Disabling sign-up on seat ${SEAT_INDEX}"
docker compose exec -T gitlab \
    curl http://localhost/api/v4/application/settings?signup_enabled=false \
        --silent \
        --fail \
        --header "Private-Token: ${ROOT_TOKEN}" \
        --header "Content-Type: application/json" \
        --request PUT

echo
echo "### Creating user seat on seat ${SEAT_INDEX}"
if ! docker compose exec -T gitlab \
        curl http://localhost/api/v4/users \
            --silent \
            --fail \
            --header "Private-Token: ${ROOT_TOKEN}" \
     | jq --exit-status '.[] | select(.username == "seat")' >/dev/null; then
    docker compose exec -T gitlab \
        curl http://localhost/api/v4/users \
            --silent \
            --fail \
            --header "Private-Token: ${ROOT_TOKEN}" \
            --header "Content-Type: application/json" \
            --request POST \
            --data "{\"username\": \"seat\", \"name\": \"seat\", \"email\": \"seat@${DOMAIN}\", \"password\": \"${SEAT_PASS}\", \"skip_confirmation\": \"true\", \"admin\": \"true\"}"
fi

echo
echo "### Creating PAT for seat on seat ${SEAT_INDEX}"
SEAT_TOKEN="$(openssl rand -hex 32)"
if ! docker compose exec -T gitlab \
        curl http://localhost/api/v4/user \
            --silent \
            --fail \
            --output /dev/null \
            --header "Private-Token: ${SEAT_TOKEN}"; then
    docker compose exec -T gitlab \
        gitlab-rails runner -e production "user = User.find_by_username('seat'); token = user.personal_access_tokens.create(scopes: [:api, :read_api, :read_user, :read_repository, :write_repository], name: 'demo'); token.set_token('${SEAT_TOKEN}'); token.save!"
fi

echo
echo "### Creating project for demos"
if ! docker compose exec -T gitlab \
    curl \
         --silent \
         --url http://localhost/api/v4/users/seat/projects \
         --header "Private-Token: ${SEAT_TOKEN}" \
    | jq --exit-status '.[] | select(.name == "demo")' >/dev/null; then
    docker compose exec -T gitlab \
        curl \
            --url "http://localhost/api/v4/projects" \
            --request POST \
            --header "Private-Token: ${SEAT_TOKEN}" \
            --header "Content-Type: application/json" \
            --data '{"name": "demo", "import_url": "https://github.com/nicholasdille/container-slides"}'
fi
git config --global user.name "seat"
git config --global user.email "seat@seat${SEAT_INDEX}.inmylab.de"
git config --global credential.helper store
echo "https://seat:${SEAT_PASS}@gitlab.seat${SEAT_INDEX}.inmylab.de" >"${HOME}/.git-credentials"
if ! git show-ref --quiet refs/heads/main; then
    (
        mkdir -p /tmp/demo
        cd /tmp/demo
        git clone "https://gitlab.seat${SEAT_INDEX}.inmylab.de/seat/demo" .
        git checkout --orphan main
        git rm -rf .
        git commit --allow-empty -m "root commit"
        git push origin main
        cd /tmp
        rm -rf demo
    )
fi
docker compose exec -T gitlab \
    curl \
        --url "http://localhost/api/v4/projects/seat%2fdemo" \
        --request PUT \
        --header "Private-Token: ${SEAT_TOKEN}" \
        --data 'default_branch=main'

echo
echo "### Retrieving runner registration token on seat ${SEAT_INDEX}"
export REGISTRATION_TOKEN="$(
    docker compose exec -T gitlab \
        gitlab-rails runner -e production "puts Gitlab::CurrentSettings.current_application_settings.runners_registration_token"
)"

echo
echo "### Starting runner on seat ${SEAT_INDEX}"
docker compose build --pull runner
docker compose up -d runner

echo
echo "### Starting remaining services on seat ${SEAT_INDEX}"
docker compose build --pull \
    --build-arg "USER=seat" \
    --build-arg "EMAIL=seat@seat${SEAT_INDEX}.inmylab.de" \
    --build-arg "GIT_CRED=https://seat:${SEAT_PASS}@gitlab.seat${SEAT_INDEX}.inmylab.de"
docker compose up -d

echo
echo "### Done with seat ${SEAT_INDEX}"
