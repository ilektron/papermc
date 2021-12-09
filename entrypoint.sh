#!/bin/bash

set -e

USER_ID=${PUID:-9001}
GROUP_ID=${PGID:-9001}
echo "Starting with $USER_ID:$GROUP_ID (UID:GID)"
groupmod -g $GROUP_ID papermc
usermod -u $USER_ID -G papermc papermc

echo "Running minecraft server"

exec su-exec $USER_ID /usr/bin/java -jar -Xms$MEMORYSIZE -Xmx$MEMORYSIZE $JAVAFLAGS /opt/minecraft/paperclip.jar --nojline nogui
