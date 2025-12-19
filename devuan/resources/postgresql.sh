#!/bin/sh

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#includes
. ./config.sh
. ./colors.sh
. ./environment.sh

#send a message
echo "Install PostgreSQL"

#generate a random password
password=$(dd if=/dev/urandom bs=1 count=20 2>/dev/null | base64)

#install message
echo "Install PostgreSQL and create the database and users\n"

#included in the distribution
if [ ."$database_repo" = ."system" ]; then
	if [ ."$database_host" = ."127.0.0.1" ] || [ ."$database_host" = ."::1" ] ; then
		apt-get install -q -y sudo postgresql
	else
		apt-get install -q -y sudo postgresql-client
	fi
fi

# install postgres
if [ ."$database_host" = ."127.0.0.1" ] || [ ."$database_host" = ."::1" ] ; then
	if [ ."$database_version" = ."latest" ]; then
		apt-get install -y sudo postgresql
	else
		apt-get install -y sudo postgresql-$database_version
	fi
else
	apt-get install -y sudo postgresql-client
fi

#install the database backup
#cp backup/fusionpbx-backup /etc/cron.daily
#cp backup/fusionpbx-maintenance /etc/cron.daily
#chmod 755 /etc/cron.daily/fusionpbx-backup
#chmod 755 /etc/cron.daily/fusionpbx-maintenance
#sed -i "s/zzz/$password/g" /etc/cron.daily/fusionpbx-backup
#sed -i "s/zzz/$password/g" /etc/cron.daily/fusionpbx-maintenance

#initialize the database
pg_createcluster $database_version main

#replace scram-sha-256 with md5
sed -i /etc/postgresql/$database_version/main/pg_hba.conf -e '/^#/!s/scram-sha-256/md5/g'

#init.d
if [ ."$database_host" = ."127.0.0.1" ] || [ ."$database_host" = ."::1" ] ; then
    /usr/sbin/service postgresql restart
fi

#move to /tmp to prevent a red herring error when running sudo with psql
cwd=$(pwd)
cd /tmp
if [ ."$database_host" = ."127.0.0.1" ] || [ ."$database_host" = ."::1" ] ; then
	#reload the config
  sudo -u postgres psql -c "SELECT pg_reload_conf();"

	#set client encoding
	sudo -u postgres psql -c "SET client_encoding = 'UTF8';";

	#add the database users and databases
	sudo -u postgres psql -c "CREATE DATABASE fusionpbx;";

 	#add the users and grant permissions
	sudo -u postgres psql -c "CREATE ROLE fusionpbx WITH SUPERUSER LOGIN PASSWORD '$password';"
	sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE fusionpbx to fusionpbx;"

 	#update the fusionpbx user password
	#ALTER USER fusionpbx WITH PASSWORD 'newpassword';
fi

cd $cwd

#set the ip address
#server_address=$(hostname -I)
