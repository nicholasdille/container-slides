#!/bin/sh
set -o errexit

case "$1" in
    sh|bash)
        set -- "$@"
    ;;
    *)
        set -- nginx "$@"
    ;;
esac

exec "$@"