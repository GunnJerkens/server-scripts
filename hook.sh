#!/bin/bash

read -ep "  Path to the bare repository on this server: " git_root
postreceive_path="$git_root/hooks/post-receive"

if [ -e "$postreceive_path" ]; then
  read -n 1 -p "  The post-receive hook already exists. Overwrite? (y/n): " confirm
  echo -ne "\n"
  if [ "$confirm" != y ]; then
    echo "  exiting"
    exit 0
  fi
fi

staging_branch=develop
production_branch=master

read -p "  Staging branch ($staging_branch): " other_staging_branch

if [ -n "$other_staging_branch" ]; then
  staging_branch=$other_staging_branch
fi

read -p "  Production branch ($production_branch): " other_production_branch

if [ -n "$other_production_branch" ]; then
  production_branch=$other_production_branch
fi

read -ep "  Path to staging working copy: " staging_working_path

read -ep "  Path to production working copy: " production_working_path

if [ -z "$staging_working_path$production_working_path" ]; then
  echo -e "  You must specify a staging or production working copy, or both.\n  exiting"
  exit 0
fi

echo "  ..."

wd=`pwd`

cat > "$postreceive_path" <<EOF
branch=\$(git rev-parse --symbolic --abbrev-ref \$1)
cd "$wd"
EOF

if [ -n "$staging_working_path" ]; then
  # Create staging working copy if it doesn't exist yet
  if [ ! -d "$staging_working_path" ]; then
    mkdir -pq "$staging_working_path"
    git clone "$git_root" "$staging_working_path"
    cd "$staging_working_path"
    git checkout $staging_branch
    git submodule update --init
    cd "$wd"
  fi
  #TODO: getting error `remote: hooks/post-receive: line 2: [: =: unary operator expected`
  cat >> "$postreceive_path" <<EOF
if [ "\$branch" = "$staging_branch" ]; then
  cd "$staging_working_path"
  env -i git fetch origin
  env -i git reset --hard origin/$staging_branch
  env -i git checkout $staging_branch
  env -i git submodule update --init
  cd "$wd"
fi
EOF
fi

if [ -n "$production_working_path" ]; then
  # Create production working copy if it doesn't exist yet
  if [ ! -d "$production_working_path" ]; then
    mkdir -pq "$production_working_path"
    git clone "$git_root" "$production_working_path"
    cd "$production_working_path"
    git checkout $production_branch
    cd "$wd"
  fi
  cat >> "$postreceive_path" <<EOF
if [ "\$branch" = "$production_branch" ]; then
  cd "$production_working_path"
  env -i git fetch origin
  env -i git reset --hard origin/$production_branch
  env -i git checkout $production_branch
  env -i git submodule update --init
  cd "$wd"
fi
EOF
fi

chmod ugo+x "$postreceive_path"

echo -e "  The hook has been added at $postreceive_path"
