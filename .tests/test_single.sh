#!/bin/sh -eu

################################################################################
#
# Arguments
#
################################################################################

###
### Validate arguments
###
if [ "${#}" != "3" ]; then
	echo "Error: Invalid number of arguments"
	exit 1
fi

if [ ! -d "${1}" ]; then
	echo "Error: Not a directory: ${1}"
	exit 1
fi

###
### Get arguments
###
DEVILBOX_PATH="$( echo "${1}"| sed 's/\/*$//' )" # remove last slash(es): /
DEVILBOX_SERVER="${2}"
DEVILBOX_VERSION="${3}"



################################################################################
#
# Bootstrap
#
################################################################################

###
### Source library
###
. "${DEVILBOX_PATH}/.tests/.lib.sh" "${DEVILBOX_PATH}"

###
### Reset .env file
###
reset_env_file

###
### Enable debug mode
###
set_debug_enable

###
### Alter host ports
###
set_host_port_httpd "80"
set_host_port_mysql "33060"
set_host_port_pgsql "54320"



################################################################################
#
# Test
#
################################################################################

###
### Docker default versions to use
###
_httpd="apache-2.2"
_mysql="mariadb-10.2"
_pysql="9.6"
_php="php-fpm-7.0"

###
### Set specific version
###
if [ "${DEVILBOX_SERVER}" = "httpd" ]; then
	_httpd="${DEVILBOX_VERSION}"
	_head="HTTPD: ${DEVILBOX_VERSION}"
elif [ "${DEVILBOX_SERVER}" = "mysql" ]; then
	_mysql="${DEVILBOX_VERSION}"
	_head="MYSQL: ${DEVILBOX_VERSION}"
elif [ "${DEVILBOX_SERVER}" = "pgsql" ]; then
	_pgsql="${DEVILBOX_VERSION}"
	_head="PGSQL: ${DEVILBOX_VERSION}"
elif [ "${DEVILBOX_SERVER}" = "php" ]; then
	_php="${DEVILBOX_VERSION}"
	_head="PHP: ${DEVILBOX_VERSION}"
fi

###
### Go
###
devilbox_start "${_httpd}" "${_mysql}" "${_pysql}" "${_php}" "${_head}"
debilbox_test
devilbox_stop



