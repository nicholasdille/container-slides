#!/bin/sh
set -o errexit

case "$1" in
    sh|bash)
        set -- "$@"
    ;;
    *)
        set -- ps "$@"
    ;;
esac

exec "$@"