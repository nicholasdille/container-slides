#!/bin/bash

echo "Generating ssh host keys..."
ssh-keygen -A >/dev/null 2>&1

echo "Start the supervisord"
exec supervisord -c /etc/supervisord.conf