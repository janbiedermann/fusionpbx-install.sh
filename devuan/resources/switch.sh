#!/bin/sh

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#includes
. ./config.sh
. ./colors.sh
. ./environment.sh

if [ .$switch_source = .true ]; then
	if [ ."$switch_branch" = "master" ]; then
		echo "MASTER"
		switch/source-master.sh
	else
		echo "RELEASE"
		switch/source-release.sh
	fi

	#add sounds and music files
	switch/source-sounds.sh

	#copy the switch conf files to /etc/freeswitch
	switch/conf-copy.sh

	#set the file permissions
	switch/source-permissions.sh

	#sysvinit service
	switch/source-sysvinit.sh
else
	if [ ."$switch_branch" = "master" ]; then
		if [ .$switch_package_all = .true ]; then
			switch/package-master-all.sh
		else
			switch/package-master.sh
		fi
	else
		if [ .$switch_package_all = .true ]; then
			switch/package-all.sh
		else
			switch/package-release.sh
		fi
	fi

	#copy the switch conf files to /etc/freeswitch
	switch/conf-copy.sh

	#set the file permissions
	switch/package-permissions.sh

	#sysvinit service
	switch/package-sysvinit.sh
fi
