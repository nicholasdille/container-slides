#!/bin/bash
set -o errexit -o pipefail

echo "######################"
echo "###                ###"
echo "### GitLab         ###"
echo "###                ###"
echo "######################"

# Clone repo on server
if ! ssh gitlab true; then
    echo "gitlab not reachable"
    exit 1
fi
if ssh gitlab test -d /root/container-slides; then
    echo "### Pulling updates"
    ssh gitlab git -C /root/container-slides pull
else
    echo "### Cloning repository"
    ssh gitlab git -C /root clone https://github.com/nicholasdille/container-slides
fi
# Copy seats.json to 160/000/server
if ! test -f seats.json; then
    echo "ERROR: Missing seats.json"
    exit 1
fi
scp seats.json gitlab:/root/container-slides/160_gitlab_ci/000_rollout/server/
# Run 160/000/server/bootstrap.sh
ssh gitlab env -C /root/container-slides/160_gitlab_ci/000_rollout/server/ bash bootstrap.sh

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
# Copy seats.json to 160/000/server
if ! test -f seats.json; then
    echo "ERROR: Missing seats.json"
    exit 1
fi
scp seats.json runner:/root/container-slides/160_gitlab_ci/000_rollout/runner/
# Run 160/000/runner/bootstrap.sh
ssh runner env -C /root/container-slides/160_gitlab_ci/000_rollout/runner/ bash bootstrap.sh

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
# Copy seats.json to 160/000/server
if ! test -f seats.json; then
    echo "ERROR: Missing seats.json"
    exit 1
fi
scp seats.json vscode:/root/container-slides/160_gitlab_ci/000_rollout/vscode/
# Run 160/000/vscode/bootstrap.sh
ssh vscode env -C /root/container-slides/160_gitlab_ci/000_rollout/vscode/ bash bootstrap.sh
