#!/bin/bash
set -o errexit -o pipefail

echo "######################"
echo "###                ###"
echo "### vscode         ###"
echo "###                ###"
echo "######################"

if ! test -f ../002_hcloud/infrastructure.json; then
    echo "ERROR: Unable to find infrastructure.json."
    exit 1
fi

EVENT_NAME="$( jq --raw-output '.name' ../002_hcloud/infrastructure.json )"
SEAT_COUNT="$( jq --raw-output '.count' ../002_hcloud/infrastructure.json )"
DOMAIN="$( jq --raw-output '.domain' ../002_hcloud/infrastructure.json )"

echo "EVENT_NAME: ${EVENT_NAME}"
echo "SEAT_COUNT: ${SEAT_COUNT}"
echo "DOMAIN    : ${DOMAIN}"

for INDEX in $( seq 0 $(( SEAT_COUNT - 1)) ); do
    IP="$( jq --raw-output --arg index "${INDEX}" '.seats[] | select(.index == $index) | .ip' ../002_hcloud/infrastructure.json )"
    PASSWORD="$( jq --raw-output --arg index "${INDEX}" '.seats[] | select(.index == $index) | .password' ../002_hcloud/infrastructure.json )"

    SSH_CMD="ssh -i id_rsa root@${IP}"
    SCP_CMD="scp -i id_rsa"

    # Check availability
    if ! ${SSH_CMD} true; then
        echo "runner not reachable"
        exit 1
    fi

    # Clone repo on server
    if ${SSH_CMD} test -d /root/container-slides; then
        echo "### Pulling updates"
        ${SSH_CMD} git -C /root/container-slides pull
    else
        echo "### Cloning repository"
        ${SSH_CMD} git -C /root clone https://github.com/nicholasdille/container-slides
    fi

    # Prepare and copy env file
    cat >env-$INDEX <<EOF
SEAT_INDEX=$INDEX
IP=$IP
DOMAIN=$DOMAIN
VSCODE_PASSWORD=$PASSWORD
EOF
    ${SCP_CMD} env-$INDEX root@${IP}:~/container-slides/180_observability/000_infrastructure/003_vscode/.env

    # Launch remote bootstrap
    ${SSH_CMD} env -C /root/container-slides/180_observability/000_infrastructure/003_vscode bash bootstrap-remote.sh
done
