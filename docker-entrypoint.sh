#!/bin/sh

# map host keys
KEYDIR=${SSH_HOSTKEYS_DIR:-/etc/ssh/keys}
echo "Using host keys from $KEYDIR..."
find $KEYDIR  -name 'ssh_host_*' -not -name '*.pub' -exec chmod o-rwx {} \;
find $KEYDIR  -name 'ssh_host_*' -not -name '*.pub' -exec chgrp ssh_keys {} \;

cd /etc/ssh
find $KEYDIR  -name 'ssh_host_*' -exec ln -sf {} \;

# start supervisord
SUPERVISORD_CONFIG=${SUPERVISORD_CONFIG:-/etc/supervisord.conf}
echo "Starting with supervisord" $(/usr/bin/supervisord --version) "with $SUPERVISORD_CONFIG..."
exec /usr/bin/supervisord --configuration $SUPERVISORD_CONFIG

