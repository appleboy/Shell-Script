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
    echo 'Usage: '$0' [--help|-h] [percona|mariadb|server|initial]'
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
    initial
}

install_mariadb() {
    # https://downloads.mariadb.org/mariadb/repositories/
    # https://kb.askmonty.org/en/installing-mariadb-with-yum/
    wget https://gist.github.com/appleboy/5277201/raw/46e3d42e79e89eb3f5dcf3d2bb5965dc8c818ab7/MariaDB+5.5+CentOS -O /etc/yum.repos.d/MariaDB.repo
    initial
    yum -y install MariaDB-Galera-server MariaDB-client galera
}

install_percona_repository () {
    # replacing x86_64 with i386 if you are not running a 64-bit operating system
    rpm -Uhv http://www.percona.com/downloads/percona-release/percona-release-0.0-1.x86_64.rpm
    yum -y install percona-xtrabackup
}

install_php() {
    yum -y install php php-fpm php-xcache php-pecl-xdebug php-mysql php-pdo php-gd php-pecl-memcached php-devel
    # Zend OPCache
    pecl install channel://pecl.php.net/ZendOpcache-7.0.2
}

install_nginx_spdy() {
    # install dependence library
    yum -y install pcre-devel openssl-devel libxslt-devel gd-devel perl-ExtUtils-Embed GeoIP-devel
    # install nginx 1.4.x up version with spdy module
    [ -f /tmp/nginx-1.4.3.tar.gz ] || wget http://nginx.org/download/nginx-1.4.3.tar.gz -O /tmp/nginx-1.4.3.tar.gz
    # download openssl library
    [ -f /tmp/openssl-1.0.1e.tar.gz ] || wget http://www.openssl.org/source/openssl-1.0.1e.tar.gz -O /tmp/openssl-1.0.1e.tar.gz
    [ -d /tmp/nginx-1.4.3 ] && cd /tmp/nginx-1.4.3 && make clean
    [ -d /tmp/openssl-1.0.1e ] && rm -rf /tmp/openssl-1.0.1e
    [ -d /tmp/nginx-1.4.3 ] || tar -zxvf /tmp/nginx-1.4.3.tar.gz -C /tmp
    [ -d /tmp/openssl-1.0.1e ] || tar -zxvf /tmp/openssl-1.0.1e.tar.gz -C /tmp
    # generate makefile
    cd /tmp/nginx-1.4.3 && ./configure \
        --prefix=/usr/share/nginx \
        --sbin-path=/usr/sbin/nginx \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --http-log-path=/var/log/nginx/access.log \
        --pid-path=/var/run/nginx.pid \
        --user=nginx \
        --group=nginx \
        --with-http_realip_module \
        --with-http_addition_module \
        --with-http_xslt_module \
        --with-http_image_filter_module \
        --with-http_geoip_module \
        --with-http_sub_module \
        --with-http_dav_module \
        --with-http_flv_module \
        --with-http_mp4_module \
        --with-http_gzip_static_module \
        --with-http_random_index_module \
        --with-http_secure_link_module \
        --with-http_degradation_module \
        --with-http_stub_status_module \
        --with-http_perl_module \
        --with-mail \
        --with-mail_ssl_module \
        --with-http_ssl_module \
        --with-http_spdy_module \
        --with-openssl=/tmp/openssl-1.0.1e
    cd /tmp/nginx-1.4.3 && make && make install
}

server() {
    # Remove unnecessary Packages.
    remove_package
    # stop iptables
    chkconfig iptables off
    /etc/init.d/iptables stop
    # install RHEL EPEL Repo.
    install_epel
    output "Install Server Packages."
    yum -y install make git tmux wget

    # CentOS Linux v6.x
    wget http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm
    rpm -ivh nginx-release-centos-6-0.el6.ngx.noarch.rpm
    # install web server.
    yum -y install nginx haproxy xinetd
    # install php
    install_php

    # install MariaDB server
    install_mariadb

    # install Percona backup script
    install_percona_repository

    # https://github.com/appleboy/MySQLTuner-perl
    wget https://raw.github.com/appleboy/MySQLTuner-perl/master/mysqltuner.pl -O /usr/local/bin/mysqltuner
    chmod a+x /usr/local/bin/mysqltuner

    # https://launchpad.net/mysql-tuning-primer
    wget https://launchpad.net/mysql-tuning-primer/trunk/1.6-r1/+download/tuning-primer.sh -O /usr/local/bin/tuning-primer
    chmod a+x /usr/local/bin/tuning-primer

    # install gcc
    yum -y install gcc python-devel

    # install python pip tool and fabric command
    yum -y install python-pip
    pip install fabric

    # https://github.com/seb-m/pyinotify
    pip install pyinotify

    # install memcached
    yum -y install memcached

    # install SysBench command tool
    yum -y install sysbench

    # install Gearman daemon
    yum -y install libgearman gearmand libgearman-devel libdrizzle
    # install php extension
    pecl install channel://pecl.php.net/gearman-1.1.2

    # Remote terminal application. ref: http://mosh.mit.edu
    yum -y install mosh

    # Redirect TCP connections
    yum -y install redir

    # install rubygems command
    yum -y install rubygems

    # update rubygems
    gem install rubygems-update
    update_rubygems

    # install capistrano tool
    gem install capistrano

    # start daemon
    chkconfig nginx on
    chkconfig haproxy on
    chkconfig php-fpm on
    chkconfig gearmand on
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
    "mariadb")
        install_mariadb
        ;;
    "percona")
        install_percona_repository
        ;;
    "nginx")
        install_nginx_spdy
        ;;
    *)
        usage $0
        ;;
esac
