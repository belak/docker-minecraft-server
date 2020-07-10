#!/bin/bash

# This script checks for dependencies and downloads them if necessary before
# calling start-run.sh.

export SERVER="./.jars/minecraft_server.${MINECRAFT_VERSION// /_}.jar"
export FABRIC_INSTALLER="./.jars/fabric-installer-$FABRIC_VERSION.jar"
export FABRIC_MARKER=".fabric-installed-$FABRIC_VERSION"

JAVA=$JAVA_HOME/bin/java

# Ensure the .jars directory exists
if [[ ! -d .jars ]]; then
  mkdir .jars
fi

# Ensure we have the vanilla minecraft server downloaded.
if [[ ! -e $SERVER ]]; then
  version_manifest_url=$(curl -fsSL 'https://launchermeta.mojang.com/mc/game/version_manifest.json' | jq --arg MINECRAFT_VERSION "$MINECRAFT_VERSION" --raw-output '[.versions[]|select(.id == $MINECRAFT_VERSION)][0].url')
  download_url=$(curl -fsSL "$version_manifest_url" | jq --raw-output '.downloads.server.url')

  curl -fsSL -o $SERVER $download_url
fi

# If server.jar isn't a symlink or the link doesn't match the minecraft server
# location, overwrite it. Fabric needs the name of the jar to be server.jar.
if [[ ! -L server.jar || ! "$(readlink server.jar)" -ef "$SERVER" ]]; then
  ln -sf $SERVER server.jar
fi

# Fabric is unique because we need to run something to generate the actual jar
# to run the server, so we use a marker file so we can tell when we've already
# done this step.
if [[ ! -e $FABRIC_INSTALLER || ! -f $FABRIC_MARKER ]]; then
  fabric_download_url="https://maven.fabricmc.net/net/fabricmc/fabric-installer/$FABRIC_VERSION/fabric-installer-$FABRIC_VERSION.jar"
  curl -fsSL -o $FABRIC_INSTALLER $fabric_download_url

  $JAVA -jar $FABRIC_INSTALLER server -mcversion $MINECRAFT_VERSION
  touch $FABRIC_MARKER
fi

exec /usr/local/lib/mc/start-run.sh
