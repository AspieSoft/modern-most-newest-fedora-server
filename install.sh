#!/bin/bash

cd $(dirname "$0")
dir="$PWD"

#todo: download bin from github

bash ./bin/scripts/install.sh "$1"
