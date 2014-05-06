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
#   2011/03/14 first release
#   2011/03/15 add default_group default_home default_shell for config
#   2011/03/25 rewrite process command line
#   2013/04/30 add default group which is not exist and change password format '!${username}!'
#   2013/07/19 support set password command
#
################################################################################

VERSION="0.1"
ROOT_UID=0
#
# config
#
samba_enable=0
default_group="user"
default_home="/home/user"
default_shell="/bin/bash"

#
# main function
#

function displayErr() {
    echo
    echo $1;
    echo
    exit 1;
}

function usage() {
    echo 'Usage: '$0' [-h|[--action|-a]] [add|del] Username [Password]'
    exit 1;
}

execute () {
    $* >/dev/null
    if [ $? -ne 0 ]; then
        displayErr "ERROR: executing $*"
    fi
}

if [ "$UID" -ne "$ROOT_UID" ]; then
    displayErr "Must be root to run this script."
fi

# Process command line...
while [ $# -gt 0 ]; do
    case $1 in
        --help | -h)
            usage $0
        ;;
        --action | -a) shift; action=$1; shift; username=$1; shift; password=$1; shift; ;;
        *) usage $0; ;;
    esac
done

test -z $action && usage $0
test -z $username && usage $0

# check home exist
test -d ${default_home} || mkdir -p ${default_home}

# check user group exist
group_exist=$(awk -F ":" '{printf $1 "\n"}' /etc/group | grep "^${default_group}$")
test -z ${group_exist} && groupadd ${default_group}

case $action in
    add)
        # check username exist
        username_exist=$(awk -F ":" '{printf $1 "\n"}' /etc/passwd | grep "^${username}$")

        if [ ! -z ${username_exist} ] ; then
            displayErr "Username $username exist, please change it"
        fi

        # add user
        cmd=$(useradd -c "$username" -g $default_group -d "${default_home}/$username" -m -s $default_shell $username)

        # set user password for Ubuntu
        # password=$(echo "!${username}!" | mkpasswd -s)
        # set user password for CentOS (ref: http://stackoverflow.com/questions/2150882/how-to-automatically-add-user-account-and-password-with-a-bash-script)
        # $(echo "!${username}!" | passwd "${username}" --stdin)

        # get default password
        test -z ${password} && password="!${username}!"
        # set user password
        $(echo "${username}:${password}" | chpasswd)

        # add samba user
        [ $samba_enable -ne "0" ] && ((echo $username; echo $username) | smbpasswd -L -s -a $username > /dev/null && smbpasswd -L -s -e $username > /dev/null && echo "add samba user ${username}")
        # add execute permission.
        [ -z $cmd ] && chmod +x "${default_home}/$username"
        [ -z $cmd ] && echo "add username $username successfully"
        ;;
    del)
        [ $samba_enable -ne "0" ] && (smbpasswd -x $username > /dev/null && echo "delete samba user ${username}")
        userdel -r $username && echo "delete user ${username} and remove home directory"
        ;;
    *)
        usage $0
        ;;
esac
