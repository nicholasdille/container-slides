#!/bin/bash
set -o errexit -o pipefail

echo "######################"
echo "###                ###"
echo "### kind           ###"
echo "###                ###"
echo "######################"

if ! test -f ../002_infrastructure/infrastructure.json; then
    echo "ERROR: Unable to find ../002_infrastructure/infrastructure.json."
    exit 1
fi

if ! type htpasswd; then
    echo "ERROR: Missing htpasswd."
    exit 1
fi

EVENT_NAME="$( jq --raw-output '.name' ../002_infrastructure/infrastructure.json )"
SEAT_COUNT="$( jq --raw-output '.count' ../002_infrastructure/infrastructure.json )"
DOMAIN="$( jq --raw-output '.domain' ../002_infrastructure/infrastructure.json )"
SSH_KEY_FILE=../002_infrastructure/ssh

echo "EVENT_NAME: ${EVENT_NAME}"
echo "SEAT_COUNT: ${SEAT_COUNT}"
echo "DOMAIN    : ${DOMAIN}"

for INDEX in $( seq 0 $(( SEAT_COUNT - 1)) ); do
    IP="$( jq --raw-output --arg index "${INDEX}" '.seats[] | select(.index == $index) | .ip' ../002_infrastructure/infrastructure.json )"
    PASSWORD="$( jq --raw-output --arg index "${INDEX}" '.seats[] | select(.index == $index) | .password' ../002_infrastructure/infrastructure.json )"

    SSH_CMD="ssh -i ${SSH_KEY_FILE} root@${IP}"
    SCP_CMD="scp -i ${SSH_KEY_FILE}"

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

    # Launch remote bootstrap
    ${SSH_CMD} env -C /root/container-slides/180_observability/000_infrastructure/003_kubernetes bash bootstrap-remote.sh

    ${SCP_CMD} root@${IP}:~/.kube/config kubeconfig.k8s${INDEX}
done
