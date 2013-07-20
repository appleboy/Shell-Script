#!/bin/bash
#################################################
# Date:     2013/07/19
# Author:   appleboy (appleboy.tw AT gmail.com)
# Web:      http://blog.wu-boy.com
#
# Program:
#   Add multiple user account via config file.
#   Please copy ../adduser.sh /usr/sbin folder
#
# History:
#   2013/07/19 first release
#
#################################################

VERSION="0.1"
ROOT_UID=0

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
    echo 'Usage: '$0' [-h|-a|-d] config_file_path'
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
        -h)
            usage $0
        ;;
        --action | -a) shift; action=$1; shift; username=$1; shift; password=$1; shift; ;;
        *) usage $0; ;;
    esac
done

cat config.txt | while read USER PASSWORD
do
    echo "Create user: ${USER}"
    create_user --action add ${USER} ${PASSWORD}
done

cat config.txt | while read USER PASSWORD
do
    echo "Delete user: ${USER}"
    create_user --action del ${USER} ${PASSWORD}
done
