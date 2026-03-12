#!/bin/bash
set -o errexit -o pipefail

echo "######################"
echo "###                ###"
echo "### vscode         ###"
echo "###                ###"
echo "######################"

if ! test -f ../002_hcloud/state.json; then
    echo "ERROR: Terraform state not found."
    exit 1
fi

make id_rsa ips.txt

INDEX=0
for IP in $(cat ips.txt); do
    SSH_CMD="ssh -i id_rsa root@${IP}"
    SCP_CMD="scp -i id_rsa"

    # Check availability
    if ! "${SSH_CMD}" true; then
        echo "runner not reachable"
        exit 1
    fi

    # Clone repo on server
    if "${SSH_CMD}" test -d /root/container-slides; then
        echo "### Pulling updates"
        "${SSH_CMD}" git -C /root/container-slides pull
    else
        echo "### Cloning repository"
        "${SSH_CMD}" git -C /root clone https://github.com/nicholasdille/container-slides
    fi

    # Prepare and copy env file
    VSCODE_PASSWORD="$( jq --raw-output --arg index $INDEX '.seats[] | select(.index == $index) | .password' ../000_creds/seats.json )"
    DOMAIN="$( jq --raw-output --arg index $INDEX '.domain' ../000_creds/seats.json )"
    cat >env-$INDEX <<EOF
SEAT_INDEX=$INDEX
IP=$IP
DOMAIN=$DOMAIN
VSCODE_PASSWORD=$VSCODE_PASSWORD
EOF
    "${SCP_CMD}" env-$INDEX root@${IP}:~/env

    # Launch remote bootstrap
    "${SSH_CMD}" env -C /root/container-slides/180_observability/000_infrastructure/003_vscode bash bootstrap-remote.sh

    INDEX=$(( INDEX + 1 ))
done
