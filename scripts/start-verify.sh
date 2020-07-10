#!/bin/bash

# This script verifies the server should be good to start then execs
# start-deps.sh

if [[ -z $MINECRAFT_VERSION ]]; then
  echo Missing MINECRAFT_VERSION
  exit 2
fi

if [[ -z $FABRIC_VERSION ]]; then
  echo Missing FABRIC_VERSION
  exit 2
fi

if ! touch /data/.verify_access; then
  echo "ERROR: /data doesn't seem to be writable. Please make sure attached directory is writable by uid=$(id -u)"
  exit 2
fi

rm /data/.verify_access || true

exec /usr/local/lib/mc/start-deps.sh
