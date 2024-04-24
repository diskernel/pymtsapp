#!/bin/bash

set -e

CHECKPORT=$(nc -z 127.0.0.1 80 && echo "busy" || echo "free")

function checkport {
	if [ "$CHECKPORT" == "free" ]; then
		echo "Port :80 is free. Now will be running docker container..."
		sleep 2	
		docker run --rm --name webapp -p 80:5000 -d diskernel/pymtsapp:v0.1
	else
		echo "Port :80 is currently busy, release this port and try again"
		exit 1
	fi
}

if [ "$USER" != "root" ]; then
	echo 'Run script with sudo!'
	exit 1
fi

if ! docker --version; then
	echo "Docker is not installed!"
	echo "This fix will take a few minutes..."
	sleep 2
	apt -y install docker.io
	checkport
else 
	echo "Docker is already installed!"
	sleep 2
	checkport
fi
