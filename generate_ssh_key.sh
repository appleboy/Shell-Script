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

test -d ~/.ssh && displayErr "Please remove or backup .ssh folder first"

mkdir -p ~/.ssh
ssh-keygen -t rsa -C $1
displayErr "Generating SSH Keys Completely"

