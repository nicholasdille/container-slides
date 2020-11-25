#!/bin/bash

echo "Creating the user: ${USER}"
addgroup docker
adduser -D ${USER} -G docker -s /bin/bash > /dev/null 2>&1
echo "${USER}:${PASSWORD}" | chpasswd > /dev/null 2>&1

echo "Generating ssh host keys..."
ssh-keygen -A > /dev/null 2>&1

echo "Start the supervisord"
exec supervisord -c /etc/supervisord.conf