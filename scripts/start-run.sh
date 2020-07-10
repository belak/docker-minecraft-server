#!/bin/bash

# This script deterimines final settings and runs the server.

# TODO: set the proper values for java so we have enough memory for the
# server.

exec $JAVA_HOME/bin/java -jar fabric-server-launch.jar
