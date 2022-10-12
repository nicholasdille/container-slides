#!/bin/bash
set -o errexit

echo
echo "### Retrieving runner registration token"
export REGISTRATION_TOKEN="$(
    docker compose exec -T gitlab \
        gitlab-rails runner -e production "puts Gitlab::CurrentSettings.current_application_settings.runners_registration_token"
)"

echo
echo "### Starting runner"
docker compose build --pull runner
docker compose up -d runner
