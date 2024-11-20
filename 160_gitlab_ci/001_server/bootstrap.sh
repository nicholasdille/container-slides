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

# Copy seats.json to 160/001
if ! test -f ../000_rollout/seats.json; then
    echo "ERROR: Missing seats.json"
    exit 1
fi
scp ../000_rollout/seats.json gitlab:/root/container-slides/160_gitlab_ci/001_server/

# Run 160/001/bootstrap-remote.sh
ssh gitlab env -C /root/container-slides/160_gitlab_ci/001_server/ bash bootstrap-remote.sh
