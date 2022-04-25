#!/bin/bash
set -o errexit

php-fpm8
exec nginx -g 'daemon off;'