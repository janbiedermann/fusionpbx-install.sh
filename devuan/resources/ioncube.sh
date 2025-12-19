#!/bin/sh

#move to script directory so all relative paths work
cd "$(dirname "$0")" 2>/dev/null

#includes
. ./config.sh
. ./colors.sh
. ./environment.sh

#show cpu details
echo "cpu architecture: $cpu_architecture"
echo "cpu name: $cpu_name"

#make sure unzip is install
apt-get install -y unzip

#remove the ioncube directory if it exists
if [ -d "ioncube" ]; then
        rm -Rf ioncube;
fi

#get the ioncube 64 bit loader
wget --no-check-certificate https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.zip

#uncompress the file
unzip ioncube_loaders_lin_x86-64.zip

#remove the zip file
rm ioncube_loaders_lin_x86-64.zip

#copy the loader to the correct directory
if [ ."$php_version" = ."8.2" ]; then
		#copy the php extension .so into the php lib directory
		cp ioncube/ioncube_loader_lin_8.2.so /usr/lib/php/20220829

		#add the 00-ioncube.ini file
		echo "zend_extension = /usr/lib/php/20220829/ioncube_loader_lin_8.2.so" > /etc/php/8.2/fpm/conf.d/00-ioncube.ini
		echo "zend_extension = /usr/lib/php/20220829/ioncube_loader_lin_8.2.so" > /etc/php/8.2/cli/conf.d/00-ioncube.ini

		#restart the service
		/usr/sbin/service php8.2-fpm restart
fi
if [ ."$php_version" = ."8.4" ]; then
		#copy the php extension .so into the php lib directory
		cp ioncube/ioncube_loader_lin_8.4.so /usr/lib/php/20240924

		#add the 00-ioncube.ini file
		echo "zend_extension = /usr/lib/php/20240924/ioncube_loader_lin_8.4.so" > /etc/php/8.4/fpm/conf.d/00-ioncube.ini
		echo "zend_extension = /usr/lib/php/20240924/ioncube_loader_lin_8.4.so" > /etc/php/8.4/cli/conf.d/00-ioncube.ini

		#restart the service
		/usr/sbin/service php8.4-fpm restart
fi
