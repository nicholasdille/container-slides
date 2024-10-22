#!/bin/bash
set -o errexit

if test -f .env; then
    source .env
fi

echo
echo "### Deploying GitLab"
docker compose --file=compose.server.yaml up -d

echo
echo "### PAT for root"
if ! docker compose --file=compose.server.yaml exec -T gitlab \
        curl \
            --url http://localhost/api/v4/user \
            --silent \
            --fail \
            --output /dev/null \
            --header "Private-Token: ${GITLAB_ADMIN_TOKEN}"; then
    echo -n "    Creating..."
    docker compose --file=compose.server.yaml exec -T gitlab \
        gitlab-rails runner -e production "user = User.find_by_username('root'); token = user.personal_access_tokens.create(scopes: [:api, :read_api, :read_user, :read_repository, :write_repository, :sudo], name: 'almighty', expires_at: 365.days.from_now); token.set_token('${GITLAB_ADMIN_TOKEN}'); token.save!"
    echo "done."
fi
echo -n "    Testing... "
if docker compose --file=compose.server.yaml exec -T gitlab \
        curl \
            --url http://localhost/api/v4/user \
            --silent \
            --fail \
            --output /dev/null \
            --header "Private-Token: ${GITLAB_ADMIN_TOKEN}"; then
    echo "Ok."
else
    echo "Admin PAT does not work."
    exit 1
fi

echo
echo "### Disabling sign-up on seat ${SEAT1_INDEX}"
docker compose --file=compose.server.yaml exec -T gitlab \
    curl \
        --url http://localhost/api/v4/application/settings?signup_enabled=false \
        --silent \
        --fail \
        --header "Private-Token: ${GITLAB_ADMIN_TOKEN}" \
        --header "Content-Type: application/json" \
        --request PUT \
        --output /dev/null

echo
echo "### Retrieving runner registration token on seat ${SEAT1_INDEX}"
if test -f CI_SERVER_TOKEN; then
    echo "    Importing token from previous run"
    CI_SERVER_TOKEN="$( cat CI_SERVER_TOKEN )"

else
    echo "    Retrieving token from GitLab"
    CI_SERVER_TOKEN="$(
        curl \
            --url "http://gitlab.${DOMAIN}/api/v4/user/runners" \
            --silent \
            --show-error \
            --request POST \
            --header "Private-Token: ${GITLAB_ADMIN_TOKEN}" \
            --header "Content-Type: application/json" \
            --data '{"runner_type": "instance_type", "run_untagged": true}' \
        | jq --raw-output '.token'
    )"
    echo "${CI_SERVER_TOKEN}" >CI_SERVER_TOKEN
fi
export CI_SERVER_TOKEN

echo "### Deploying GitLab Runner"
docker compose --file=compose.server.yaml --file=compose.runner.yaml up -d

echo
echo "### User seat${SEAT1_INDEX}"
if ! docker compose --file=compose.server.yaml --file=compose.runner.yaml exec -T gitlab \
        curl \
            --url "http://localhost/api/v4/users?per_page=100" \
            --silent \
            --fail \
            --header "Private-Token: ${GITLAB_ADMIN_TOKEN}" \
        | jq --exit-status --arg user "seat${SEAT1_INDEX}" '.[] | select(.username == $user)' >/dev/null; then
    echo -n "    Creating user... "
    SEAT1_USER_ID="$(
        docker compose --file=compose.server.yaml --file=compose.runner.yaml exec -T gitlab \
            curl http://localhost/api/v4/users \
                --silent \
                --show-error \
                --fail \
                --header "Private-Token: ${GITLAB_ADMIN_TOKEN}" \
                --header "Content-Type: application/json" \
                --request POST \
                --data "{\"username\": \"seat${SEAT1_INDEX}\", \"name\": \"seat${SEAT1_INDEX}\", \"email\": \"seat${SEAT1_INDEX}@${DOMAIN}\", \"password\": \"${SEAT1_PASS}\", \"skip_confirmation\": \"true\"}" \
            | jq --raw-output '.id'
    )"
    echo "done."
else
    echo "    Already exists"
    SEAT1_USER_ID="$(
        docker compose --file=compose.server.yaml --file=compose.runner.yaml exec -T gitlab \
            curl http://localhost/api/v4/users?username=seat${SEAT1_INDEX} \
                --silent \
                --show-error \
                --fail \
                --header "Private-Token: ${GITLAB_ADMIN_TOKEN}" \
            | jq --raw-output '.[0].id'
    )"
fi
echo "    User ID ${SEAT1_USER_ID}"

echo
echo "### PAT for user seat${SEAT1_INDEX}"
if ! docker compose --file=compose.server.yaml --file=compose.runner.yaml exec -T gitlab \
        curl \
            --url http://localhost/api/v4/user \
            --silent \
            --fail \
            --output /dev/null \
            --header "Private-Token: ${SEAT1_GITLAB_TOKEN}"; then
    echo -n "    Creating PAT..."
    docker compose --file=compose.server.yaml --file=compose.runner.yaml exec -T gitlab \
        gitlab-rails runner -e production "user = User.find_by_username('seat${SEAT1_INDEX}'); token = user.personal_access_tokens.create(scopes: [:api, :read_api, :read_user, :read_repository, :write_repository], name: 'demo', expires_at: 30.days.from_now); token.set_token('${SEAT1_GITLAB_TOKEN}'); token.save!"
    echo "done."
fi
echo -n "    Testing... "
if docker compose --file=compose.server.yaml --file=compose.runner.yaml exec -T gitlab \
        curl \
            --url http://localhost/api/v4/user \
            --silent \
            --fail \
            --output /dev/null \
            --header "Private-Token: ${SEAT1_GITLAB_TOKEN}"; then
    echo "Ok."
else
    echo "User PAT does not work."
    exit 1
fi

echo
echo "### Project for demos"
# TODO: Create empty project with default branch main
if ! docker compose --file=compose.server.yaml --file=compose.runner.yaml exec -T gitlab \
        curl \
            --url "http://localhost/api/v4/users/seat${SEAT1_INDEX}/projects" \
            --silent \
            --fail \
            --header "Private-Token: ${SEAT1_GITLAB_TOKEN}" \
        | jq --exit-status '.[] | select(.name == "demo")' >/dev/null; then
    echo -n "    Creating..."
    docker compose --file=compose.server.yaml --file=compose.runner.yaml exec -T gitlab \
        curl \
            --url "http://localhost/api/v4/projects/user/${SEAT1_USER_ID}" \
            --silent \
            --show-error \
            --request POST \
            --header "Private-Token: ${GITLAB_ADMIN_TOKEN}" \
            --header "Content-Type: application/json" \
            --data '{"name": "demo"}' \
            --output /dev/null
    echo "done."

    git config --global user.name "seat${SEAT1_INDEX}"
    git config --global user.email "seat${SEAT1_INDEX}@.${DOMAIN}"
    git config --global credential.helper store
    echo "http://seat${SEAT1_INDEX}:${SEAT1_PASS}@gitlab.${DOMAIN}" >"${HOME}/.git-credentials"
    if test -d /tmp/demo; then
        rm -rf /tmp/demo
    fi
    (
        mkdir -p /tmp/demo
        cd /tmp/demo
        git clone https://github.com/nicholasdille/container-slides .
        git remote add downstream "http://gitlab.${DOMAIN}/seat${SEAT1_INDEX}/demo"
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
            git -c commit.gpgsign=false commit --allow-empty -m "root commit"
            git push downstream main
        fi
        rm -rf /tmp/demo
    )
    docker compose --file=compose.server.yaml exec -T gitlab \
        curl \
            --url "http://localhost/api/v4/projects/seat${SEAT1_INDEX}%2fdemo" \
            --silent \
            --show-error \
            --request PUT \
            --header "Private-Token: ${SEAT1_GITLAB_TOKEN}" \
            --data 'default_branch=main'
fi

echo "### Deploying GitLab Runner"
docker compose --file=compose.server.yaml --file=compose.runner.yaml --file=compose.vscode.yaml up -d
