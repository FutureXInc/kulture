#!/bin/bash
if [[ $(npm list -g --depth=0 | grep parse-server) ]]
then 
  echo "packages are already installed..."
else
  echo "installing npm packages..."
  npm install -g parse-server mongodb-runner parse-dashboard
fi
