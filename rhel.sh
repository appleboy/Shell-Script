#!/bin/bash
################################################################################
# Date:     2013/03/14
# Author:   appleboy ( appleboy.tw AT gmail.com)
# Web:      http://blog.wu-boy.com
#
# Program:
#   Install all CentOS or Fefora program automatically
#
################################################################################

usage() {
    echo 'Usage: '$0' [--help|-h] [initial]'
    exit 1;
}

output() {
    printf "\E[0;33;40m"
    echo $1
    printf "\E[0m"
}

displayErr() {
    echo
    echo $1;
    echo
    exit 1;
}

initial() {
    output "Update all packages"
    # update package and upgrade Ubuntu
    yum -y update && yum -y upgrade
}

# Process command line...
while [ $# -gt 0 ]; do
    case $1 in
        --help | -h)
            usage $0
        ;;
        *)
            action=$0
            shift;
        ;;
    esac
done

test -z $action && usage $0

case $action in
    "initial")
        initial
        ;;
    "all")
        initial
        server
        desktop
        ;;
    *)
        usage $0
        ;;
esac