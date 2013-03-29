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

remove_package() {
    # ref http://www.cyberciti.biz/faq/centos-redhat-rhel-fedora-remove-nfs-services/
    output "Remove unnecessary Server Packages."
    chkconfig nfslock off
    chkconfig rpcgssd off
    chkconfig rpcidmapd off
    chkconfig portmap off
    chkconfig nfs off
    chkconfig cups off
    yum -y remove portmap nfs-utils cups

}

# Installing RHEL EPEL Repo on Centos 5.x or 6.x
# ref: http://www.rackspace.com/knowledge_center/article/installing-rhel-epel-repo-on-centos-5x-or-6x
install_epel() {
    # Centos 5.x
    # wget http://dl.fedoraproject.org/pub/epel/5/x86_64/epel-release-5-4.noarch.rpm
    # wget http://rpms.famillecollet.com/enterprise/remi-release-5.rpm
    # rpm -Uvh remi-release-5*.rpm epel-release-5*.rpm
    # Centos 6.x
    wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
    wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
    rpm -Uvh remi-release-6*.rpm epel-release-6*.rpm
}

server() {
    # Remove unnecessary Packages.
    remove_package
    output "Install Server Packages."
    yum -y install make git tmux wget

    # install web server
    yum -y install nginx
}

# Process command line...
while [ $# -gt 0 ]; do
    case $1 in
        --help | -h)
            usage $0
        ;;
        *)
            action=$1
            shift;
        ;;
    esac
done

test -z $action && usage $0

case $action in
    "initial")
        initial
        ;;
    "server")
        initial
        server
        ;;
    *)
        usage $0
        ;;
esac