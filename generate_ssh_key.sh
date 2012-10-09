#!/bin/bash
################################################################################
# Date:     2011/06/16
# Author:   appleboy ( appleboy.tw AT gmail.com)
# Web:      http://blog.wu-boy.com
#
# Program:
#   Generating SSH Keys
#
# History:
#   2011/06/16 (first release)
#   2012/10/09 (check id_rsa and id_rsa.pub exist)
#
################################################################################

VERSION="0.1"

PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin
export PATH

function displayErr()
{
    echo $1;
    exit 1;
}

function usage()
{
    echo 'Usage: '$0' Your_email'
    exit 1;
}

if [ "$#" -lt "1" ]; then
    usage $0
fi

test -e ~/.ssh/id_rsa && displayErr "Please remove or backup ~/.ssh/id_rsa file first"
test -e ~/.ssh/id_rsa.pub && displayErr "Please remove or backup ~/.ssh/id_rsa.pub file first"

mkdir -p ~/.ssh
ssh-keygen -t rsa -C $1
displayErr "Generating SSH Keys Completely"

