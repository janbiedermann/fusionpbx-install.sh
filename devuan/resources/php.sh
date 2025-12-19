#!/bin/sh

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#includes
. ./config.sh
. ./colors.sh
. ./environment.sh

#send a message
verbose "Configuring PHP"

#install dependencies
apt-get install -y nginx
if [ ."$php_version" = ."8.2" ]; then
	apt-get install -y --no-install-recommends php8.2 php8.2-common php8.2-cli php8.2-dev php8.2-fpm php8.2-pgsql php8.2-sqlite3 php8.2-odbc php8.2-curl php8.2-imap php8.2-xml php8.2-gd php8.2-mbstring php8.2-ldap php8.2-inotify php8.2-snmp
fi
if [ ."$php_version" = ."8.4" ]; then
    # php8.4-imap is not available
	apt-get install -y --no-install-recommends php8.4 php8.4-common php8.4-cli php8.4-dev php8.4-fpm php8.4-pgsql php8.4-sqlite3 php8.4-odbc php8.4-curl php8.4-xml php8.4-gd php8.4-mbstring php8.4-ldap php8.4-inotify php8.4-snmp
fi

#update config if source is being used
if [ ."$php_version" = ."8.2" ]; then
        verbose "version 8.2"
        php_ini_file='/etc/php/8.2/fpm/php.ini'
fi
if [ ."$php_version" = ."8.4" ]; then
        verbose "version 8.4"
        php_ini_file='/etc/php/8.4/fpm/php.ini'
fi
sed 's#post_max_size = .*#post_max_size = 80M#g' -i $php_ini_file
sed 's#upload_max_filesize = .*#upload_max_filesize = 80M#g' -i $php_ini_file
sed 's#;max_input_vars = .*#max_input_vars = 8000#g' -i $php_ini_file
sed 's#; max_input_vars = .*#max_input_vars = 8000#g' -i $php_ini_file

#install ioncube
if [ .$cpu_architecture = .'x86' ]; then
	. ./ioncube.sh
fi

#restart php-fpm
if [ ."$php_version" = ."8.2" ]; then
    /usr/sbin/service php8.2-fpm restart
fi
if [ ."$php_version" = ."8.4" ]; then
    /usr/sbin/service php8.4-fpm restart
fi
