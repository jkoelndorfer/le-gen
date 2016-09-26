#!/bin/bash

if [[ -z "$REDIRECT_URL" ]]; then
    echo 'You must specify a URL to redirect to via $REDIRECT_URL.' >&2
    exit 1
fi
sed -e "s#\\\${REDIRECT_URL}#$REDIRECT_URL#" /app/default.conf.template > /etc/nginx/conf.d/default.conf
exec /usr/bin/supervisord
