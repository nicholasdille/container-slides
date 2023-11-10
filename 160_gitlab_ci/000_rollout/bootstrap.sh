#!/bin/bash
set -o errexit

if test "$(dirname "$0")" != "${PWD}"; then
    pushd "$(dirname "$0")"
fi

source /etc/profile.d/vars.sh
if test -f .env; then
    source .env
fi

export GIT_USER=seat
export GIT_EMAIL="seat@seat${SEAT_INDEX}.inmylab.de"
export GIT_CRED="https://seat:${SEAT_PASS}@gitlab.seat${SEAT_INDEX}.inmylab.de"

echo
echo "### Removing previous deployment on seat ${SEAT_INDEX}"
docker compose down --volumes

cat /etc/ssl/tls.crt /etc/ssl/tls.chain >/etc/ssl/tls.full

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

echo
echo "### PAT for root on seat ${SEAT_INDEX}"
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

echo
echo "### User seat on seat ${SEAT_INDEX}"
if ! docker compose exec -T gitlab \
        curl \
            --url http://localhost/api/v4/users \
            --silent \
            --fail \
            --header "Private-Token: ${GITLAB_ADMIN_TOKEN}" \
        | jq --exit-status '.[] | select(.username == "seat")' >/dev/null; then
    echo -n "    Creating..."
    docker compose exec -T gitlab \
        curl http://localhost/api/v4/users \
            --silent \
            --show-error \
            --fail \
            --header "Private-Token: ${GITLAB_ADMIN_TOKEN}" \
            --header "Content-Type: application/json" \
            --request POST \
            --data "{\"username\": \"seat\", \"name\": \"seat\", \"email\": \"seat@${DOMAIN}\", \"password\": \"${SEAT_PASS}\", \"skip_confirmation\": \"true\", \"admin\": \"true\"}"
    echo "done."
fi

echo
echo "### PAT for seat on seat ${SEAT_INDEX}"
if ! docker compose exec -T gitlab \
        curl \
            --url http://localhost/api/v4/user \
            --silent \
            --fail \
            --output /dev/null \
            --header "Private-Token: ${SEAT_GITLAB_TOKEN}"; then
    echo -n "    Creating..."
    docker compose exec -T gitlab \
        gitlab-rails runner -e production "user = User.find_by_username('seat'); token = user.personal_access_tokens.create(scopes: [:api, :read_api, :read_user, :read_repository, :write_repository], name: 'demo', expires_at: 365.days.from_now); token.set_token('${SEAT_GITLAB_TOKEN}'); token.save!"
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
    | jq '.id'
)"
echo "    Got ${GITLAB_USER_ID}"

echo
echo "### Project for demos"
if ! docker compose exec -T gitlab \
        curl \
            --url http://localhost/api/v4/users/seat/projects \
            --silent \
            --header "Private-Token: ${SEAT_GITLAB_TOKEN}" \
        | jq --exit-status '.[] | select(.name == "demo")' >/dev/null; then
    echo -n "    Creating..."
    docker compose exec -T gitlab \
        curl \
            --url "http://localhost/api/v4/projects/user/${GITLAB_USER_ID}" \
            --silent \
            --show-error \
            --request POST \
            --header "Private-Token: ${GITLAB_ADMIN_TOKEN}" \
            --header "Content-Type: application/json" \
            --data '{"name": "demo"}'
    echo "done."
fi
git config --global user.name "seat"
git config --global user.email "seat@seat${SEAT_INDEX}.inmylab.de"
git config --global credential.helper store
echo "https://seat:${SEAT_PASS}@gitlab.seat${SEAT_INDEX}.inmylab.de" >"${HOME}/.git-credentials"
if test -d /tmp/demo; then
    rm -rf /tmp/demo
fi
(
    mkdir -p /tmp/demo
    cd /tmp/demo
    git clone https://github.com/nicholasdille/container-slides .
    git remote add downstream "https://gitlab.seat${SEAT_INDEX}.inmylab.de/seat/demo"
    CURRENT_BRANCH="$(git branch --show-current)"
    git branch --remotes --list \
    | grep -v downstream \
    | grep -v dependabot \
    | grep -v renovate \
    | grep -v '\->' \
    | grep -v "${CURRENT_BRANCH}" \
    | while read branch; do
        git branch --track "${branch#origin/}" "$branch" || true
    done
    git push downstream --all
    if ! git show-ref --quiet refs/heads/main; then
        git checkout --orphan main
        git rm -rf .
        git commit --allow-empty -m "root commit"
        git push downstream main
    fi
    rm -rf /tmp/demo
)
docker compose exec -T gitlab \
    curl \
        --url "http://localhost/api/v4/projects/seat%2fdemo" \
        --silent \
        --show-error \
        --request PUT \
        --header "Private-Token: ${SEAT_GITLAB_TOKEN}" \
        --data 'default_branch=main'

echo
echo "### Retrieving runner registration token on seat ${SEAT_INDEX}"
export REGISTRATION_TOKEN="$(
    curl \
        --url "https://gitlab.seat${SEAT_INDEX}/api/v4/user/runners" \
        --silent \
        --show-error \
        --request POST \
        --header "Private-Token: ${SEAT_GITLAB_TOKEN}" \
        --header "Content-Type: application/json" \
        --data '{"runner_type": "instance_type", "run_untagged": true}' \
    | jq --raw-output '.token'
)"

echo
echo "### Starting runner on seat ${SEAT_INDEX}"
docker compose build --pull runner
docker compose up -d runner

echo
echo "### Starting remaining services on seat ${SEAT_INDEX}"
docker compose build --pull
docker compose up -d

echo
echo "### Done with seat ${SEAT_INDEX}"
