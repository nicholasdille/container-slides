#!/bin/bash

if test -z "${GIT_USER}" || test -z "${GIT_EMAIL}" || test -z "${GIT_CRED}"; then
    echo "ERROR: Missing environment variables GIT_USER, GIT_EMAIL, GIT_CRED."
    exit 1
fi

echo "${GIT_CRED}" >"${HOME}/.git-credentials"

mkdir -p /home/seat/demo
pushd /home/seat/demo

git init --initial-branch=main
git config --local user.name "${GIT_USER}"
git config --local user.email "${GIT_EMAIL}"
git config --local credential.helper store

git remote add origin https://gitlab.inmylab.de/${GIT_USER}/demo
git remote add upstream https://github.com/nicholasdille/container-slides

git pull origin main || true
git pull upstream || true

touch README.md
git add README.md
git commit -m "Initial commit"
git push --set-upstream origin main
