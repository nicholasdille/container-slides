#!/bin/bash

# Add local registry
docker run -d --name registry --volume $(pwd)/registry:/var/lib/registry -p 127.0.0.1:5000:5000 registry:2
