#!/bin/bash

set -e

CHECKPORT=$(nc -z 127.0.0.1 80 && echo "busy" || echo "free")

if [ "$USER" != "root" ]; then
	echo 'Run script with sudo!'
	exit 1
fi

if ! docker --version; then
	echo "Docker is not installed!"
	echo "This fix will take a few minutes..."
	apt -y install docker.io
else 
	echo "Docker is already installed!"
	sleep 1
	if [ "$CHECKPORT" == "free" ]; then
		echo "Port :80 is free. Now will be running docker container..."
		sleep 1	
		docker run --rm --name webapp -p 80:5000 -d diskernel/pymtsapp:v0.1
	else
		echo "Port :80 is currently busy, release this port and try again"
		exit 1
	fi
fi
