#!/bin/sh

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#includes
. ../config.sh
. ../colors.sh
. ../environment.sh

apt-get update && apt-get install -y curl memcached haveged apt-transport-https
apt-get update && apt-get install -y wget lsb-release gnupg2

wget -O - https://files.freeswitch.org/repo/deb/debian-release/fsstretch-archive-keyring.asc | apt-key add -
echo "deb http://files.freeswitch.org/repo/deb/debian-release/ ${os_codename_debian} main" > /etc/apt/sources.list.d/freeswitch.list
echo "deb-src http://files.freeswitch.org/repo/deb/debian-release/ ${os_codename_debian} main" >> /etc/apt/sources.list.d/freeswitch.list
apt-get update && apt-get install -y freeswitch-meta-all freeswitch-all-dbg gdb
