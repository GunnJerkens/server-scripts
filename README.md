server-scripts
==============

Server scripts for the maintenance of WordPress projects

## benefits

- Quickly syncs a production database to local/staging from staging/production  
- Quickly syncs uploads back to local or staging from staging/production  
- When syncing uploads files that do not exist in staging/production are deleted  

## basic usage

1. Copy `bin/config.sample.sh` to `bin/config.sh` and edit  
2. Place an `env_local` or `env_staging` file in the root of your project  
3. Use `bin/db_fetch.sh` to clone the database  
4. Use `bin/uploads_sync.sh` to clone the uploads  

## other usage

### db_push

This allows pushing to a remote database, use with caution.

### db_backup

This takes a dump of the current database and drops it into the defined sql directory.

### hook

This is for post-receive hooks for Git. Allowing you to push to a server as opposed to using ssh and git pull.

## cautions

If you interrupt (Ctrl+C) a db_fetch it will most likely corrupt your current database, to fix run the fetch again.

## license

MIT
