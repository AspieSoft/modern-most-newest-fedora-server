#!/bin/bash

function curl-install-if-ok {
  local skipDownload="0"
  if test -f "./bin/files/$2"; then
    modtime="$(stat -c "%y" "$2" | sed -E 's/^([0-9\-]*).*$/\1/')"
    if [ "$(date -d "$modtime" +%Y)" -le "$(date +%Y)" -o "$(date -d "$modtime" +%m)" -lt "$(date +%m)" ]; then
      local skipDownload="1"
    fi
  fi

  if [ "$skipDownload" != "1" ] && curl -s --head --request GET "$1" | grep -E "200 OK|HTTP/[0-9]+ 200" > /dev/null; then
    curl "$1" -o "$2" --create-dirs
  elif [ -s "./bin/files/$2" ]; then
    cp -f "./bin/files/$2" "$2"
  else
    mkdir -p "$(dirname "$2")"
    touch "$2"
  fi
}

function mvln {
  mv -f "$1" "$2"
  ln -s "$2" "$1"
}
