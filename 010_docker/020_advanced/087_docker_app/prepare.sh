#!/bin/bash

# Start local registry
docker run -d -p 127.0.0.1:5000:5000 registry:2
