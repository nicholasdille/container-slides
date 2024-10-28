# You are ready!

A few last words...

## Exercises tell a story :fontawesome-solid-timeline:

Each chapter focuses on a single feature

Each exercise improves the previous state

All exercises will have leave some questions unanswered

Following exercises will again improve

## Work at your own pace

Either follow topics and exercises at the instructor's pace

Or work ahead if you finish early

Please be mindful of other participants

Please do not confuse participants with your questions when racing ahead

## Don't like the demo env?

You can also use your own environment and IDE if you prefer. The following script prepares the checkout 

```bash
#!/bin/bash
set -o errexit

read -p "Please enter your seat number: " SEAT_INDEX
read -s -p "Please enter your seat password: " SEAT_PASS

echo "https://seat${SEAT_INDEX}:${SEAT_PASS}@gitlab.inmylab.de" >"${HOME}/.git-credentials.demo"

mkdir demo
pushd demo

git init --initial-branch=main
git config --local user.name "${GIT_USER}"
git config --local user.email "${GIT_EMAIL}"
git config --local credential.helper "store --file=${HOME}/.git-credentials.demo"

git remote add origin https://gitlab.inmylab.de/seat${SEAT_INDEX}/demo
git remote add upstream https://github.com/nicholasdille/container-slides

popd
```
