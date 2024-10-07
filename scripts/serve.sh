#!/bin/bash

docker run -it --rm --network host --mount type=bind,source=$PWD,target=/usr/share/nginx/html nginx
