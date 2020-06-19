#!/bin/bash

mkdir -p ~/.docker/cli-plugins
curl --silent --location https://github.com/docker/app/releases/download/v0.9.0-beta1/docker-app-linux.tar.gz | tar -xvz
mv docker-app-plugin-linux ~/.docker/cli-plugins/docker-app
