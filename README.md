# papermc

A simple Paper Minecraft Server Docker image that allows you to run 1.18+ Paper servers.

WARNING: Paper 1.18 is currently experimental and there is no ETA for when a stable version will be released. Backup your data before using this image.

## Requirements

As of version 1.18, Minecraft requires the use of Java 17. The openjdk-alpine:17 docker image doesn't contain the Java 17 release version, instead it contains an Early Access version that is not fully compatible with Paper Minecraft. Newer versions of Java, including 17, have improved memory security. You will need a newer version of docker running on your host to run Java 17 in an image. This image has been tested with Docker 20.10.11.

While you can successfully run Paper with less than ideal RAM, it's recommended to have at least 6GB to 10GB of RAM available for the JVM running minecraft. We use Aikar's flags to optimize server memory performance.

## Setup

### Building an Image

On a machine with docker installed, run the following command

```
$ docker build -t papermc:latest .
```

### Running the Server

Based off of the azul/zulu-openjdk-alpine image, the server basically provides the JDK and paperclip.jar launcher that downloads, unpacks, and patches the vanilla Minecraft server. Currently, Paper 1.18 is experimental, so use caution and backup your data before running the 1.18 server!

An example command to run to start the minecraft server would be:

```
docker run -it \
  --rm \
  -e PGID=1000 -e PUID=1000 \
  -v /some/local/folder:/data:rw \
  -p 25565:25565 \
  -m 8g \
  -e MEMORYSIZE=7G \
  -i ilektron:papermc:1.18 \
  --name minecraft-server
```

If you need to access the running server command line, you can attach using the following command

```
docker attach minecraft-server
```

To detach from your server you can use the keystroke sequence of `ctrl+p ctrl+q`.

#### Data Volume

`papermc` stores all world and server data on a volume mounted at `/data`. If you wish to be able to easily edit the server configuration, bind a local folder on the docker host to the `/data` volume using the `-v /some/local/folder:/data:rw` option with the `docker run` command.

If you are binding a local folder to the container, please create a user specific to the container and pass the user's UID and GID to the container using the `PUID` and `PGID` environment variables. The user you use must have write access to the local folder that you bind to your container. You can pass the IDs to your container using the `-e PGID=1000 -e PUID=1000` option with the `docker run` command.

To find the IDs of the user you created to use when launching the server, use the `id` command

```
$ id <dockeruser>
  uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)

```

#### Port

The image starts the server to listen on port `25565`. You can forward the port to the container running the server by using the `-p 25565:25565` option with the `docker run` command.

#### Memory

In addition to supplying docker with an amount of memory to use, you can use the `MEMORYSIZE` environment variable by using the `-e MEMORYSIZE=10G` option with the `docker run` command.

