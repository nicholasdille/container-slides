#!/bin/bash
set -o errexit -o pipefail

echo "######################"
echo "###                ###"
echo "### test           ###"
echo "###                ###"
echo "######################"

if ! test -f ../004_vscode/infrastructure.json; then
    echo "ERROR: Unable to find ../004_vscode/infrastructure.json."
    exit 1
fi

if ! type htpasswd; then
    echo "ERROR: Missing htpasswd."
    exit 1
fi

EVENT_NAME="$( jq --raw-output '.name' ../004_vscode/infrastructure.json )"
if test -z "${SEAT_COUNT}"; then
    SEAT_COUNT="$( jq --raw-output '.count' ../004_vscode/infrastructure.json )"
fi
DOMAIN="$( jq --raw-output '.domain' ../004_vscode/infrastructure.json )"
SSH_KEY_FILE=../002_infrastructure/ssh
SSH="ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
SCP="scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

echo "EVENT_NAME: ${EVENT_NAME}"
echo "SEAT_COUNT: ${SEAT_COUNT}"
echo "DOMAIN    : ${DOMAIN}"
echo

for INDEX in $( seq 0 $(( SEAT_COUNT - 1)) ); do
    echo "### Processing seat ${INDEX}"

    IP="$( jq --raw-output --arg index "${INDEX}" '.seats[] | select(.index == $index) | .ip' ../004_vscode/infrastructure.json )"

    SSH_CMD="${SSH} -i ${SSH_KEY_FILE} root@${IP}"
    SCP_CMD="${SCP} -i ${SSH_KEY_FILE}"
    
    ${SSH_CMD} env -C /root/container-slides git pull
    
    echo
done
