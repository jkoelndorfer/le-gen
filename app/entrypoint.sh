#!/bin/bash

# Set up acme-challenge directory and configure default permissions.
#
# We want to run simp_le with umask 077 so that the generated certificates
# are not world-readable. Unfortunately it's not smart enough to create the
# challenge files with more relaxed permissions, so we work around that here.
mkdir -p /var/www/.well-known/acme-challenge
setfacl -d -m g::rX /var/www/.well-known/acme-challenge
setfacl -d -m o::r /var/www/.well-known/acme-challenge

if [[ -z "$REDIRECT_URL" ]]; then
    echo 'You must specify a URL to redirect to via $REDIRECT_URL.' >&2
    exit 1
fi
sed -e "s#\\\${REDIRECT_URL}#$REDIRECT_URL#" /app/default.conf.template > /etc/nginx/conf.d/default.conf
exec /usr/bin/supervisord
