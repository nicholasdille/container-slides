#!/bin/bash
set -o errexit

if ! test -s "$(dirname $0)/.env"; then
    echo "Please create "$(dirname $0)/.env" with the required variables"
    exit 1
fi
source "$(dirname $0)/.env"

if test -z "$GOLANG_VERSION"; then
    echo "Please set GOLANG_VERSION in the .env file"
    exit 1
fi
if test -z "$CURL_VERSION"; then
    echo "Please set CURL_VERSION in the .env file"
    exit 1
fi
if test -z "$NGINX_VERSION"; then
    echo "Please set NGINX_VERSION in the .env file"
    exit 1
fi
if test -z "$DOCKER_VERSION"; then
    echo "Please set DOCKER_VERSION in the .env file"
    exit 1
fi
if test -z "$RELEASE_CLI_VERSION"; then
    echo "Please set RELEASE_CLI_VERSION in the .env file"
    exit 1
fi

CODE_BRANCHES="$(
    git ls-remote https://github.com/nicholasdille/container-slides refs/heads/160_gitlab_ci/* \
    | cut -f2 \
    | cut -d/ -f3-
)"

if test "$#" -gt 0; then
    TEMP_DIR=$1
fi
if test -z TEMP_DIR; then
    TEMP_DIR="$(mktemp -d)"
    trap 'rm -rf "$TEMP_DIR"' EXIT
    git clone https://github.com/nicholasdille/container-slides "${TEMP_DIR}"
fi

for CODE_BRANCH in ${CODE_BRANCHES}; do
    clear
    echo
    echo "### Updating code branch ${CODE_BRANCH}"
    echo

    git -C "${TEMP_DIR}" switch -q "${CODE_BRANCH}"
    git -C "${TEMP_DIR}" reset -q --hard "origin/${CODE_BRANCH}"

    if test -f .gitlab-ci.yml; then
        sed -i -E "s|golang:[0-9]+\.[0-9]+\.[0-9]+|golang:${GOLANG_VERSION}|" .gitlab-ci.yml
        sed -i -E "s|curlimages/curl:[0-9]+\.[0-9]+\.[0-9]|curlimages/curl:${CURL_VERSION}|" .gitlab-ci.yml
        sed -i -E "s|nginx:[0-9]+\.[0-9]+\.[0-9]|nginx:${NGINX_VERSION}|" .gitlab-ci.yml
        sed -i -E "s|docker:[0-9]+\.[0-9]+\.[0-9]+|docker:${DOCKER_VERSION}|" .gitlab-ci.yml
        sed -i -E "s|registry.gitlab.com/gitlab-org/release-cli:v[0-9]+\.[0-9]+\.[0-9]+|registry.gitlab.com/gitlab-org/release-cli:v${RELEASE_CLI_VERSION}|" .gitlab-ci.yml
    fi

    if test -n "$(git status --porcelain)"; then
        git diff | cat
        read -n 1 -p "Press any key to continue..."

        git -C "${TEMP_DIR}" add --all
        git -C "${TEMP_DIR}" commit --message "chore(deps): Bumped versions"
        git -C "${TEMP_DIR}" push
    fi
done
