#!/bin/bash
#################################################
# Date:     2013/07/19
# Author:   appleboy (appleboy.tw AT gmail.com)
# Web:      http://blog.wu-boy.com
#
# Program:
#   Please copy ../adduser.sh /usr/sbin folder
#   Add multiple user account via config file.
#   config file format:
#       username_1 password_1
#       username_2 password_2
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
        -a)
            shift; create=1;
        ;;
        -d)
            shift; delete=1;
        ;;
        *)
            config_path=$1; shift;
        ;;
    esac
done

test -z $create && test -z $delete && usage $0
# check defin file path.
test -z $config_path && usage $0
# check file exist.
test -f $config_path || usage $0

if [ ! -z ${create} ] && [ ${create} == "1" ]; then
    cat $config_path | while read USER PASSWORD
    do
        create_user --action add ${USER} ${PASSWORD}
    done
fi

if [ ! -z ${delete} ] && [ ${delete} == "1" ]; then
    cat $config_path | while read USER PASSWORD
    do
        create_user --action del ${USER}
    done
fi
