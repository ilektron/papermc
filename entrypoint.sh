#!/bin/bash

set -e

# Set the user id and group id of the process that we'll create
USER_ID=${PUID:-9001}
GROUP_ID=${PGID:-9001}

echo "Starting with $USER_ID:$GROUP_ID (UID:GID)"

# Change our user and group id to match what exists on the local system via the environment variabls
groupmod -g $GROUP_ID papermc
usermod -u $USER_ID -G papermc papermc

echo "Running minecraft server"

# Run all the things!
exec su-exec $USER_ID /usr/bin/java -jar -Xms$MEMORYSIZE -Xmx$MEMORYSIZE $JAVAFLAGS /opt/minecraft/paperclip.jar --nojline nogui
