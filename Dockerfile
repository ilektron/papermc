# syntax=docker/dockerfile:1

# Builds a simple 1.18 or above of a Paper Minecraft Server

# Base this on a well tested jdk build that should work with the paper jar
FROM azul/zulu-openjdk-alpine:17

MAINTAINER Stephen Farnsworth <ilektron@ilektronx.com>

# We need curl to download the correct version of paper
RUN apk add --no-cache curl bash shadow su-exec

ARG paper_version=1.18

# Copy over the script
WORKDIR /opt/minecraft
COPY ./getpaperserver.sh /
RUN chmod +x /getpaperserver.sh
RUN /getpaperserver.sh ${paper_version}

# Cleanup
RUN rm /getpaperserver.sh

# Volumes for the external data (Server, World, Config...)
# This is where all generated data will be stored. Bind a local volume to this location to expose the information to this docker container
VOLUME "/data"

# Expose minecraft port
EXPOSE 25565/tcp
EXPOSE 25565/udp

# Set memory size
ARG memory_size=7G
ENV MEMORYSIZE=$memory_size

# Set Java Flags
# For more information about these flags see https://aikar.co/2018/07/02/tuning-the-jvm-g1gc-garbage-collector-flags-for-minecraft/
ARG java_flags="-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=mcflags.emc.gs -Dcom.mojang.eula.agree=true"
# ARG java_flags="-Dcom.mojang.eula.agree=true"
ENV JAVAFLAGS=$java_flags

WORKDIR /data

# It doesn't really matter which UID or GID we use because the entrypoint script will change the server to run as the ids set by the PGID and PUID environment variables
RUN addgroup -g 9001 papermc
RUN adduser -s /bin/sh -u 9001 -G papermc -D papermc

# Copy our script that launches minecraft over to our server
COPY /entrypoint.sh /opt/minecraft
RUN chmod +x /opt/minecraft/entrypoint.sh

ENTRYPOINT ["/opt/minecraft/entrypoint.sh"]

