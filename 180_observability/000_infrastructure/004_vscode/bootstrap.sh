#!/bin/bash
set -o errexit -o pipefail

echo "######################"
echo "###                ###"
echo "### vscode         ###"
echo "###                ###"
echo "######################"

if ! test -f infrastructure.json; then
    echo "ERROR: Unable to find infrastructure.json."
    exit 1
fi

if ! type htpasswd; then
    echo "ERROR: Missing htpasswd."
    exit 1
fi

EVENT_NAME="$( jq --raw-output '.name' infrastructure.json )"
SEAT_COUNT="$( jq --raw-output '.count' infrastructure.json )"
DOMAIN="$( jq --raw-output '.domain' infrastructure.json )"
SSH_KEY_FILE=../002_infrastructure/ssh
TRAEFIK_PASSWORD="$( jq --raw-output '.traefik_password' infrastructure.json )"
TRAEFIK_HTPASSWD="$( htpasswd -nBb admin "${TRAEFIK_PASSWORD}" )"

echo "EVENT_NAME: ${EVENT_NAME}"
echo "SEAT_COUNT: ${SEAT_COUNT}"
echo "DOMAIN    : ${DOMAIN}"

for INDEX in $( seq 0 $(( SEAT_COUNT - 1)) ); do
    IP="$( jq --raw-output --arg index "${INDEX}" '.seats[] | select(.index == $index) | .ip' infrastructure.json )"
    PASSWORD="$( jq --raw-output --arg index "${INDEX}" '.seats[] | select(.index == $index) | .password' infrastructure.json )"

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

    # Prepare and copy env file
    cat >env-$INDEX <<EOF
SEAT_INDEX=$INDEX
IP=$IP
DOMAIN=$DOMAIN
TRAEFIK_PASSWORD=$TRAEFIK_PASSWORD
TRAEFIK_HTPASSWD=$( echo $TRAEFIK_HTPASSWD | sed 's/\$/\$\$/g' )
VSCODE_PASSWORD=$PASSWORD
EOF
    ${SCP_CMD} env-$INDEX root@${IP}:~/container-slides/180_observability/000_infrastructure/004_vscode/.env

    cp ../004_kubernetes/kubeconfig.k8s${INDEX} kubeconfig.k8s${INDEX}
    sed -i 's/127.0.0.1/kind-control-plane/' kubeconfig.k8s${INDEX}
    docker --host=ssh://k8s${INDEX} build --build-arg=INDEX=${INDEX} --tag code-server .

    # Launch remote bootstrap
    ${SSH_CMD} env -C /root/container-slides/180_observability/000_infrastructure/004_vscode bash bootstrap-remote.sh
done
