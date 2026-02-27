#!/bin/bash
set -o errexit

if ! test -s ssh; then
    ssh-keygen -N '' -f ssh -t ed25519
fi

hcloud ssh-key create \
    --name=o11y-local \
    --public-key-from-file=ssh.pub \
    --label=purpose=o11y-local

hcloud server create \
    --name=o11y-local \
    --type=cx43 \
    --location=nbg1 \
    --image=ubuntu-24.04 \
    --ssh-key=o11y-local \
    --user-data-from-file=cloud-init \
    --label=purpose=o11y-local

read -n 1 -p "Press any key to destroy..."

hcloud server delete o11y-local
hcloud ssh-key delete o11y-local