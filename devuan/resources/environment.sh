#!/bin/sh

#operating system details
os_name=$(lsb_release -is)
os_codename=$(lsb_release -cs)
os_mode='unknown'

#cpu details
cpu_name=$(uname -m)
cpu_architecture='unknown'
cpu_mode='unknown'

#set the environment path
export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

#debian release name
if [ .$os_codename = .'excalibur' ]; then
		os_codename_debian='trixie'
elif [ .$os_codename = .'daedalus' ]; then
		os_codename_debian='bookworm'
else
    error "couldn't set a matching debian codename, are you using an old devuan release?"
		exit 1
fi

#check what the CPU and OS are
if [ .$cpu_name = .'i386' ]; then
	os_mode='32'
	if [ .$(grep -o -w 'lm' /proc/cpuinfo | head -n 1) = .'lm' ]; then
		cpu_mode='64'
	else
		cpu_mode='32'
	fi
	cpu_architecture='x86'
elif [ .$cpu_name = .'i686' ]; then
	os_mode='32'
	if [ .$(grep -o -w 'lm' /proc/cpuinfo | head -n 1) = .'lm' ]; then
		cpu_mode='64'
	else
		cpu_mode='32'
	fi
	cpu_architecture='x86'
elif [ .$cpu_name = .'x86_64' ]; then
	os_mode='64'
	if [ .$(grep -o -w 'lm' /proc/cpuinfo | head -n 1) = .'lm' ]; then
		cpu_mode='64'
	else
		cpu_mode='32'
	fi
	cpu_architecture='x86'
else
	error "You are using an unsupported cpu '$cpu_name'"
	exit 3
fi

if [ .$cpu_architecture = .'x86' ]; then
	if [ .$os_mode = .'32' ]; then
		error "You are using a 32bit OS this is unsupported"
		if [ .$cpu_mode = .'64' ]; then
			warning " Your CPU is 64bit you should consider reinstalling with a 64bit OS"
		fi
		switch_source=true
		switch_package=false
	elif [ .$os_mode = .'64' ]; then
		verbose "Correct CPU and Operating System detected"
	else
		error "Unknown Operating System mode '$os_mode' is unsupported"
		switch_source=true
		switch_package=false
	fi
else
	error "You are using an unsupported architecture '$cpu_architecture'"
	warning "Detected environment was :-"
	warning "os_name:'$os_name'"
	warning "os_codename:'$os_codename'"
	warning "os_mode:'$os_mode'"
	warning "cpu_name:'$cpu_name'"
	exit 3
fi

#set php version
if [ .$os_codename = .'daedalus' ]; then
    php_version=8.2
elif [ .$os_codename = .'excalibur' ]; then
    php_version=8.4
fi
