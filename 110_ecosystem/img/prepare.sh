#!/bin/bash

docker run -d --name pod alpine \
    sh -c 'while true; do sleep 10; done'
docker run -d --name registry \
    --pid container:pod --network container:pod registry:2
docker run -d --name img \
    --pid container:pod --network container:pod \
    --mount type=bind,source=$(pwd),target=/src --workdir /src \
    --security-opt seccomp=unconfined \
    --security-opt apparmor=unconfined \
    --entrypoint sh r.j3ss.co/img:v0.5.7 \
    -c 'while true; do sleep 10; done'
docker exec --user 0 img apk add --update-cache curl git bash
