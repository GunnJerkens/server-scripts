#!/bin/bash

. `dirname $0`/bootstrap.sh

size=""

if [ -z "$remote_env" ]; then
  echo "this server appears to be at the top of the food chain (production?)"
  exit 1
elif [ -z "$remote_ssh" ]; then
  echo "please specify a remote SSH user"
  exit 1
fi

if [ "$1" != "go" ]; then
  echo "[DRY RUN] use `basename $0` go to sync for real"
  options="--dry-run"
else
  options="--delete"
fi

if [ ! -z "$max_size" ]; then
  size="--max-size=$max_size"
fi

rsync -ruvPz -e "ssh -p $remote_ssh_port" $options $size $remote_ssh:$remote_uploads/ $env_uploads/

if [ "$1" = "go" ]; then
  echo -n "(Making uploads writable by the group) "
  sudo chmod -R g+w $env_uploads/
fi
