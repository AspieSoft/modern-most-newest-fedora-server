#!/bin/bash

cd $(dirname "$0")

if [ "$UID" != "0" ]; then
  echo "Please Run As Root!"
  exit
fi

#todo: download bin from github

source ./bin/scripts/install.sh "$1"
