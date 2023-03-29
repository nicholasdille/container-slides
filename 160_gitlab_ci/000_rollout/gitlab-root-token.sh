#!/bin/bash
set -o errexit

TOKEN=$1
if test -z "${TOKEN}"; then
    echo "ERROR: Token must be specified as only parameter."
    exit 1
fi

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

echo
echo "### Creating PAT for root on seat ${SEAT_INDEX}"
if ! docker compose exec -T gitlab \
        curl \
            --url http://localhost/api/v4/user \
            --silent \
            --fail \
            --output /dev/null \
            --header "Private-Token: ${TOKEN}"; then
    docker compose exec -T gitlab \
        gitlab-rails runner -e production "user = User.find_by_username('root'); token = user.personal_access_tokens.create(scopes: [:api, :read_api, :read_user, :read_repository, :write_repository, :sudo], name: 'almighty'); token.set_token('${TOKEN}'); token.save!"
fi

echo
echo "### Done with seat ${SEAT_INDEX}"
