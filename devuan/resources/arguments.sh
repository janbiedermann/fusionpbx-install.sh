#!/bin/sh

#Process command line options only if we haven't been processed once
if [ -z "$CPU_CHECK" ]; then
	export script_name=`basename "$0"`
	ARGS=$(getopt -n '$script_name' -o h -l help,use-switch-source -- "$@")

	if [ $? -ne 0 ]; then
		error "Failed parsing options."
		exit 1
	fi

	HELP=false

	while true; do
	  case "$1" in
		--use-switch-source ) SWITCH_SOURCE=true; shift ;;
		-h | --help ) HELP=true; shift ;;
		-- ) shift; break ;;
		* ) break ;;
	  esac
	done

	if [ .$HELP = .true ]; then
		warning "Debian installer script"
		warning "	--use-switch-source will use freeswitch from source rather than ${green}(default:packages)"
		exit;
	fi
fi
