#!/bin/bash
set -o errexit

HTTP_CODES=(200 500 429 404)

while true; do
    CODE=${HTTP_CODES[$RANDOM % ${#HTTP_CODES[@]}]}
    curl http://localhost:9898/status/$CODE
done