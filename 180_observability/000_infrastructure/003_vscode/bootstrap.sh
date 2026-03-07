#!/bin/bash
set -o errexit -o pipefail

echo "######################"
echo "###                ###"
echo "### VSCode         ###"
echo "###                ###"
echo "######################"

# Clone repo on server
if ! ssh vscode true; then
    echo "vscode not reachable"
    exit 1
fi
if ssh vscode test -d /root/container-slides; then
    echo "### Pulling updates"
    ssh vscode git -C /root/container-slides pull
else
    echo "### Cloning repository"
    ssh vscode git -C /root clone https://github.com/nicholasdille/container-slides
fi

# Copy seats.json to 160/003
if ! test -f ../000_rollout/seats.json; then
    echo "ERROR: Missing seats.json"
    exit 1
fi
scp ../000_rollout/seats.json vscode:/root/container-slides/160_gitlab_ci/003_vscode/

# Copy personal_access_tokens.json to 160/003
if ! test -f ../001_server/personal_access_tokens.json; then
    echo "ERROR: Missing personal_access_tokens.json"
    exit 1
fi
scp ../001_server/personal_access_tokens.json vscode:/root/container-slides/160_gitlab_ci/003_vscode/

# Run 160/003/bootstrap.sh
ssh vscode env -C /root/container-slides/160_gitlab_ci/003_vscode/ bash bootstrap-remote.sh
