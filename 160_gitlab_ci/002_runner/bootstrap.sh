#!/bin/bash
set -o errexit -o pipefail

echo "######################"
echo "###                ###"
echo "### Runner         ###"
echo "###                ###"
echo "######################"

# Clone repo on server
if ! ssh runner true; then
    echo "runner not reachable"
    exit 1
fi
if ssh runner test -d /root/container-slides; then
    echo "### Pulling updates"
    ssh runner git -C /root/container-slides pull
else
    echo "### Cloning repository"
    ssh runner git -C /root clone https://github.com/nicholasdille/container-slides
fi

# Copy seats.json to 160/002
if ! test -f ../000_rollout/seats.json; then
    echo "ERROR: Missing seats.json"
    exit 1
fi
scp ../000_rollout/seats.json runner:/root/container-slides/160_gitlab_ci/002_runner/

# Copy runner_token.json to 160/002
if ! test -f ../001_server/runner_token.json; then
    echo "ERROR: Missing runner_token.json"
    exit 1
fi
scp ../001_server/runner_token.json runner:/root/container-slides/160_gitlab_ci/002_runner/

# Run 160/002/bootstrap-remote.sh
ssh runner env -C /root/container-slides/160_gitlab_ci/002_runner/ bash bootstrap-remote.sh
