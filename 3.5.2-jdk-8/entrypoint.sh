#!/bin/sh

set -e

USER_ID=${LOCAL_USER_ID:-9001}

useradd --shell /bin/bash -u $USER_ID -o -c "" -M -d $LOCAL_USER_HOME user

chown user:user $LOCAL_USER_HOME

if [ "$1" = 'mvn' ]; then
    exec /usr/local/bin/gosu user "$@"
fi

exec "$@"