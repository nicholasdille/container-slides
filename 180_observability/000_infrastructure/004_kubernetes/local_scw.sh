#!/bin/bash
set -o errexit

if ! test -s ssh; then
    ssh-keygen -N '' -f ssh -t ed25519
fi

scw instance server create \
    name=o11y-local \
    image=ubuntu_resolute \
    type=BASIC2-A8C-16G \
    cloud-init=@cloud-init \
    stopped=true
SERVER_ID="$( scw instance server list --output json | jq -r '.[] | select(.name == "o11y-local") | .id' )"

scw instance ssh add-key \
    server-id="${SERVER_ID}" \
    public-key="$(cat ssh.pub)"
scw instance server start "${SERVER_ID}"

read -n 1 -p "Press any key to destroy..."

scw instance server stop "${SERVER_ID}"
while test "$( scw instance server list --output json | jq -r '.[].state' )" != "stopped"; do
    sleep 5
done
scw instance server delete "${SERVER_ID}"
