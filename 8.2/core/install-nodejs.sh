#!/bin/bash -e
set -e
NODEJS_VERSION=$1
if [ -n "$NODEJS_VERSION" ]; then
  sudo apt-get purge nodejs -y
  echo "Installation de nodejs $NODEJS_VERSION"
  sudo echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODEJS_VERSION.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
  sudo apt-get update && sudo apt-get install nodejs -y
  sudo rm -rf /var/lib/apt/lists/*
else
  echo 'NODEJS_VERSION argument is required'
fi