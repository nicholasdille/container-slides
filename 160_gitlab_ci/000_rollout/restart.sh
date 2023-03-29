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
echo "### Starting remaining services on seat ${SEAT_INDEX}"
docker compose build --pull \
    --build-arg "GIT_USER=seat" \
    --build-arg "GIT_EMAIL=seat@seat${SEAT_INDEX}.inmylab.de" \
    --build-arg "GIT_CRED=https://seat:${SEAT_PASS}@gitlab.seat${SEAT_INDEX}.inmylab.de"
docker compose up -d

echo
echo "### Done with seat ${SEAT_INDEX}"
