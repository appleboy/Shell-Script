#!/bin/bash
################################################################################
# Date:     2011/03/14
# Author:   appleboy ( appleboy.tw AT gmail.com)
# Web:      http://blog.wu-boy.com
#
# Program:
#   Use the function to add system user and samba permission.
#
# History:
#   2011/03/14 (first release)
#   2011/03/15 (add default_group default_home default_shell for config)
#   2011/03/25 (rewrite process command line)
#
################################################################################

VERSION="0.1"
#
# config
#
samba_enable=1
default_group="router"
default_home="/home/Router"
default_shell="/bin/bash"

#
# main function
#

function displayErr()
{
    echo
    echo $1;
    echo
    exit 1;
}

function usage()
{
    echo 'Usage: '$0' --action [add|del] Username'
    exit 1;
}

execute ()
{
    $* >/dev/null
    if [ $? -ne 0 ]; then
        displayErr "ERROR: executing $*"
    fi
}

# Process command line...
while [ $# -gt 0 ]; do
    case $1 in
        --help | -h)
            usage $0
        ;;
        --action) shift; action=$1; shift; username=$1; shift; ;;
        *) usage $0; ;;
    esac
done

test -z $action && usage $0
test -z $username && usage $0

# check home exist
test -d ${default_home} || mkdir -p ${default_home}

case $action in
    "add")
        # check if username exist
        username_exist=$(awk -F ":" '{printf $1 "\n"}' /etc/passwd | grep "^${username}$")

        if [ ! -z ${username_exist} ] ; then
            displayErr "Username $username exist, please change it"
        fi

        # generate password and add user
        password=$(echo $username | mkpasswd -s)
        cmd=$(useradd -c "$username" -g $default_group -d "${default_home}/$username" --password $password -m -s $default_shell $username)

        # add samba user
        [ $samba_enable -ne "0" ] && ((echo $username; echo $username) | smbpasswd -L -s -a $username > /dev/null && smbpasswd -L -s -e $username > /dev/null && echo "add samba user ${username}")
        [ -z $cmd ] && echo "add username $username successfully";

        ;;
    "del")
        [ $samba_enable -ne "0" ] && (smbpasswd -x $username > /dev/null && echo "delete samba user ${username}")
        userdel -r $username && echo "delete user ${username} and remove home directory"
        ;;
    *)
        usage $0
        ;;
esac
