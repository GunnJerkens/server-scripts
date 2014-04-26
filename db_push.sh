#!/bin/bash

. `dirname $0`/bootstrap.sh

if [[ -z $remote_env ]]; then
  echo "this server appears to be at the top of the food chain (production?)"
  exit 1
else
  read -p "Is the database at $env ok to overwrite $remote_env? That seems like a bad idea. [yN] "
  if [[ $REPLY =~ ^[Yy](es)? ]]; then
    echo "Gonna give you 5 seconds to think about that. Hit ctrl+c to cancel."
    for digit in 5 4 3 2 1; do
      echo -n "$digit "
      sleep 1
    done
    echo -e "\npushing database from $env to $remote_env..."
  else
    echo "exiting"
    exit 1
  fi
fi

if [ -z "$remote_ssh" ]; then
  mysqldump -u$env_username -p$env_password $env_database | mysql -u$remote_username -p"$remote_password" $remote_database
else
  mysqldump -u$env_username -p$env_password $env_database | ssh -p $remote_ssh_port $remote_ssh "mysql -u$remote_username -p\"$remote_password\" $remote_database"
fi
