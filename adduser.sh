#!/bin/bash
################################################################ 
# Date:		2011/03/14
# Author:   appleboy ( appleboy.tw AT gmail.com)
# Web:      http://blog.wu-boy.com
#
# Program:
#	Use function to add system user and add samba permission.
#
# History:
#	2011/03/14 by Bo-Yi Wu (first release)
#
################################################################

#
# config
#
samba_enable=1

#
# main function
#

function displayErr()
{
	echo $1;
	exit 1;
}

function usage()
{
	echo 'Usage: '$0' [add|del] Username'
	exit 1;
}

if [ -z $1 ] || [ -z $2 ] ; then
	usage
fi

action=$1
username=$2

case $action in
	"add")
		# check if username exist		
		username_exist=$(awk -F ":" '{printf $1 "\n"}' /etc/passwd | grep "^${username}$")
		
		if [ ! -z ${username_exist} ] ; then
		    error_message="Username $username exist, please change it"
		    displayErr "${error_message}"
		fi
		
		# add user
		password=$(echo $username | mkpasswd -s)
		cmd=$(useradd -c "$username" -g router -d "/home/Router/$username" --password $password -m -s "/bin/bash" $username)

		# add samba user
		[ $samba_enable -ne "0" ] && ((echo $username; echo $username) | smbpasswd -L -s -a $username > /dev/null && smbpasswd -L -s -e $username > /dev/null && echo "add samba user ${username}")
		[ -z $cmd ] && displayErr "add username $username successfully";
		
		;;
	"del")
		[ $samba_enable -ne "0" ] && (smbpasswd -x $username > /dev/null && echo "delete samba user ${username}")
		userdel -r $username && echo "delete user ${username} and remove home directory"
		;;
	*)
		usage
		;;
esac
