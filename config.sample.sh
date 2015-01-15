#!/bin/bash

# If you're not sure what value a variable should have, please leave it blank.
#
# Anything wrapped in {} is set during the init.sh script

production_database={db_prod}
production_username={un_prod}
production_password='{pw_prod}'
# ssh user and server, or blank (e.g. remoteuser@remoteserver)
production_ssh={ssh_prod}@{hostname_prod}
production_ssh_port={port_prod}
production_webroot={wr_prod}
production_uploads=$production_webroot/shared

staging_database={db_staging}
staging_username=$production_username
staging_password=$production_password
# ssh user and server, or blank (e.g. remoteuser@remoteserver)
staging_ssh={ssh_staging}@{hostname_staging}
staging_ssh_port={port_staging}
staging_webroot={wr_staging}
staging_uploads=$staging_webroot/shared

local_database={db_dev}
local_username=root
local_password=
local_webroot=$(dirname $0)/../public
local_uploads=$local_webroot/shared

#leave this empty to use the default, otherwise "local", "staging" or "production"
remote_env=

sql_dir=`dirname $0`/../sql
