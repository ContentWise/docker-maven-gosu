#!/bin/sh

USER_ID=${LOCAL_USER_ID:-9001}

adduser -s /bin/bash -u $USER_ID -g "" -D -H -h $LOCAL_USER_HOME user

chown user $LOCAL_USER_HOME

if [ "$1" = 'mvn' ] || [ "$1" = 'make' ]; then
    exec /usr/local/bin/gosu user "$@"
fi

exec "$@"