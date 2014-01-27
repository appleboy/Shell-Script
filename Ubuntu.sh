#!/bin/bash
################################################################################
# Date:     2011/04/18
# Author:   appleboy ( appleboy.tw AT gmail.com)
# Web:      http://blog.wu-boy.com
# modified: 2013/04/09
#
# Program:
#   Install all Ubuntu program automatically
#
################################################################################

# get sever os name: ubuntu or debian
server_name=`lsb_release -ds | awk -F ' ' '{printf $1}' | tr A-Z a-z`
version_name=`lsb_release -cs`

usage() {
    echo 'Usage: '$0' [--help|-h] [-i|--install] [s4cmd|timezone|jenkins|mosh|gearman|nginx|nginx-spdy|percona|mariadb|clean-kernel|server|desktop|initial|all]'
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
    output "Update all packages and install aptitude tool command."
    # update package and upgrade Ubuntu
    apt-get -y update && apt-get -y upgrade
    # terminal-based package manager (terminal interface only)
    apt-get -y install aptitude
}

install_jenkins() {
    # ref https://wiki.jenkins-ci.org/display/JENKINS/Installing+Jenkins+on+Ubuntu
    output "Install Jenkins Server."
    aptitude -y install openjdk-7-jre openjdk-7-jdk
    wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
    sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
    aptitude -y update
    aptitude -y install jenkins
}

install_mariadb() {
    output "Install Mariadb Server."
    # Ubuntu 12.10 don't support python-software-properties
    # http://blog.xrmplatform.org/solution-for-add-apt-repository-command-not-found-ubuntu-12-10-server/
    aptitude -y install software-properties-common
    aptitude -y install python-software-properties
    apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db
    # repository url ref: https://downloads.mariadb.org/mariadb/repositories/
    if [ "$server_name" == "debian" ] ; then
        grep -ir "mariadb" /etc/apt/sources.list* > /dev/null
        if [ $? == "1" ]; then
            output "Add Mariadb Repository to /etc/apt/sources.list"
            echo "deb http://ftp.yz.yamagata-u.ac.jp/pub/dbms/mariadb/repo/5.5/${server_name} ${version_name} main" >> /etc/apt/sources.list
        fi
    else
        add-apt-repository "deb http://ftp.yz.yamagata-u.ac.jp/pub/dbms/mariadb/repo/5.5/${server_name} ${version_name} main"
    fi
    aptitude -y update
    # install mariadb-galera-server and galera library
    aptitude -y install mariadb-galera-server-5.5 galera
}

install_mosh() {
    if [ "$server_name" == "debian" ] ; then
        aptitude -y install mosh
    else
        aptitude -y install python-software-properties
        add-apt-repository -y ppa:keithw/mosh
        aptitude -y update
        aptitude -y install mosh
    fi
}

install_percona () {
    output "Install Percona Repository."
    apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A
    grep -ir "percona" /etc/apt/sources.list* > /dev/null
    if [ $? == "1" ]; then
        output "Add Percona Repository to /etc/apt/sources.list"
        echo "deb http://repo.percona.com/apt ${version_name} main" >> /etc/apt/sources.list
        echo "deb-src http://repo.percona.com/apt ${version_name} main" >> /etc/apt/sources.list
    fi
    aptitude -y update
    aptitude -y install percona-server-server-5.5 percona-server-client-5.5 percona-xtrabackup
}

install_nginx() {
    wget http://nginx.org/keys/nginx_signing.key -O /tmp/nginx_signing.key
    sudo apt-key add /tmp/nginx_signing.key
    grep -ir "nginx.org" /etc/apt/sources.list* > /dev/null
    if [ $? == "1" ]; then
        output "Add Nginx Repository to /etc/apt/sources.list"
        echo "deb http://nginx.org/packages/${server_name}/ ${version_name} nginx" >> /etc/apt/sources.list
        echo "deb-src http://nginx.org/packages/${server_name}/ ${version_name} nginx" >> /etc/apt/sources.list
    fi
    aptitude -y update
    aptitude -y install nginx
}

install_nginx_spdy() {
    # install dependence package.
    aptitude -y install libpcre3-dev libgd-dev libgd2-xpm-dev libgeoip-dev libxslt-dev
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

install_gearmand() {
    aptitude -y install libboost-program-options-dev gperf libcloog-ppl0 libpq-dev libmemcached-dev libevent-dev
    # install mariadb header file
    aptitude -y install libmariadbclient-dev uuid-dev
    [ -f /tmp/libdrizzle-5.1.4.tar.gz ] || wget https://launchpad.net/libdrizzle/5.1/5.1.4/+download/libdrizzle-5.1.4.tar.gz -O /tmp/libdrizzle-5.1.4.tar.gz
    [ -d /tmp/libdrizzle-5.1.4 ] && rm -rf /tmp/libdrizzle-5.1.4
    [ -f /tmp/gearmand-1.1.11.tar.gz ] || wget https://launchpad.net/gearmand/1.2/1.1.11/+download/gearmand-1.1.11.tar.gz -O /tmp/gearmand-1.1.11.tar.gz
    [ -d /tmp/gearmand-1.1.11 ] && rm -rf /tmp/gearmand-1.1.11
    cd /tmp && tar xvfz libdrizzle-5.1.4.tar.gz && cd libdrizzle-5.1.4 && ./configure && make && make install
    cd /tmp && tar xvfz gearmand-1.1.11.tar.gz && cd gearmand-1.1.11 && ./configure && make && make install
}

install_proftpd() {
    # install ftp daemon
    aptitude -y install proftpd
}

install_timezone() {
    # update time zone
    cp -r /usr/share/zoneinfo/Asia/Taipei /etc/localtime
    aptitude -y install ntpdate
    ntpdate time.stdtime.gov.tw
    # write time to clock.
    hwclock -w
}

install_s4cmd() {
    cd ~ && git clone https://github.com/bloomreach/s4cmd.git
    cp -r s4cmd/s4cmd.py /usr/bin/
}

server() {
    output "Install Server Packages."

    aptitude -y install openssh-server sudo
    aptitude -y install build-essential
    aptitude -y install subversion
    aptitude -y install bison
    aptitude -y install flex
    aptitude -y install gettext
    aptitude -y install g++
    aptitude -y install libncurses5-dev
    aptitude -y install libncursesw5-dev
    aptitude -y install exuberant-ctags
    aptitude -y install sharutils
    aptitude -y install help2man
    aptitude -y install zlib1g-dev libssl-dev
    aptitude -y install gawk
    aptitude -y install libid3tag0-dev
    aptitude -y install libgdbm-dev
    aptitude -y install xinetd nfs-kernel-server minicom build-essential libncurses5-dev uboot-mkimage autoconf automake

    # install git from kernel git://git.kernel.org/pub/scm/git/git.git
    aptitude -y install libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev

    # git core and git flow command
    aptitude -y install git git-core git-doc git-gui git-flow

    # mkpasswd command
    aptitude -y install whois

    # vim
    aptitude -y install vim

    # install MariaDB server
    # install_mariadb

    # install Percona XtraDB Server (default: 5.5 version)
    install_percona

    # install nginx web server
    install_nginx

    # apache mpm worker and php-fpm service
    # aptitude -y install apache2-mpm-worker libapache2-mod-geoip libapache2-mod-rpaf libapache2-mod-fastcgi
    # install stable php 5.4
    [ "$server_name" == "ubuntu" ] && add-apt-repository ppa:ondrej/php5 -y
    aptitude -y install php5 php5-xdebug php5-xcache php5-cli php5-fpm php5-mysql php5-curl php5-geoip php5-gd php5-intl php5-mcrypt php5-memcache php5-imap php5-ming php5-ps php5-pspell php5-recode php5-snmp php5-sqlite php5-tidy php5-xmlrpc php5-xsl php5-cgi spawn-fcgi openssl geoip-database memcached
    aptitude -y install php5-dev php-pear

    # Remote terminal application. ref: http://mosh.mit.edu
    install_mosh

    # man program
    aptitude -y install most

    # version tool: subversion program
    aptitude -y install subversion

    # grep-like program specifically for large source trees
    aptitude -y install ack-grep

    # install ruby
    aptitude -y install ruby rake rubygems

    # install mercurial
    aptitude -y install mercurial

    # install ffmpeg
    aptitude -y install ffmpeg

    # install irssi
    aptitude -y install irssi

    # install python easy_install
    aptitude -y install python-pip
    # install fabric command
    aptitude -y install python-dev
    pip install fabric

    # install terminal multiplexer (http://tmux.sourceforge.net/)
    aptitude -y install tmux

    # install ImageMagic
    aptitude -y install imagemagick

    # update rubygems
    gem install rubygems-update
    update_rubygems

    # install compass tool and livereload (https://github.com/guard/guard-livereload)
    gem install compass
    gem install rb-inotify guard-livereload yajl-ruby

    # install capistrano tool
    gem install capistrano

    # Optimize images using multiple utilities
    # ref: https://github.com/toy/image_optim
    gem install image_optim

    # S3CP: Commands-line tools for Amazon S3 file manipulation
    # ref: https://github.com/aboisvert/s3cp
    gem install s3cp
    # usage:
    # export AWS_ACCESS_KEY_ID=xxxx
    # export AWS_SECRET_ACCESS_KEY=xxx

    # install PPA purge command
    aptitude -y install ppa-purge

    # install sshfs command
    aptitude -y install sshfs

    # install SysBench command tool
    aptitude -y install sysbench

    # remove nfs and rpcbind
    aptitude -y --purge remove nfs-common
    aptitude -y --purge remove rpcbind

    # Don't install rar and unrar together.
    # ref: http://yaohua.info/2012/05/19/ubuntu-extracting-rar-invalid-encoding/
    aptitude -y --purge remove rar
    aptitude -y install unrar

    # Redirect TCP connections
    aptitude -y install redir

    # Htop is an ncursed-based process viewer similar to top
    aptitude -y install htop atop

    # Atop is an ASCII full-screen performance monitor
    aptitude -y install atop

    # install Munin Monitor
    aptitude -y install munin-node munin

    # update time zone
    cp -r /usr/share/zoneinfo/Asia/Taipei /etc/localtime
    aptitude -y install ntpdate
    ntpdate time.stdtime.gov.tw
    # write time to clock.
    hwclock -w

    # install Gearman Daemon
    aptitude -y install gearman gearman-job-server libgearman-dev libdrizzle0
    pecl install channel://pecl.php.net/gearman-1.1.2

    # support Zend OPcache on PHP 5.2, 5.3 and 5.4
    pecl install channel://pecl.php.net/ZendOpcache-7.0.2

    # install nvm
    # https://github.com/creationix/nvm
    aptitude -y install curl
    curl https://raw.github.com/creationix/nvm/master/install.sh | sh
    . ~/.nvm/nvm.sh
    nvm install 0.10.25
    nvm use 0.10.25

    # coffee script
    npm install -g coffee-script
    # express server
    npm install -g express
    # Handlebars.js command
    npm install -g handlebars
    # RequireJS command line tool
    npm install -g requirejs
    # transfer javascript to coffee script tool
    npm install -g js2coffee
    # UglifyJS 2
    npm install -g uglify-js
    # UglifyJS 1
    npm install -g uglify-js@1
    # install twitter bower package
    npm install -g bower
    # install grunt task package
    npm install -g grunt-cli

    # install PHP-CS-Fixer
    # https://github.com/fabpot/PHP-CS-Fixer
    wget http://cs.sensiolabs.org/get/php-cs-fixer.phar -O /usr/local/bin/php-cs-fixer
    chmod a+x /usr/local/bin/php-cs-fixer

    # install NySQL monitor
    aptitude -y install mytop

    # https://github.com/appleboy/MySQLTuner-perl
    wget https://raw.github.com/appleboy/MySQLTuner-perl/master/mysqltuner.pl -O /usr/local/bin/mysqltuner
    chmod a+x /usr/local/bin/mysqltuner

    # https://launchpad.net/mysql-tuning-primer
    wget https://launchpad.net/mysql-tuning-primer/trunk/1.6-r1/+download/tuning-primer.sh -O /usr/local/bin/tuning-primer
    chmod a+x /usr/local/bin/tuning-primer

    # install cpanm before install Vimana
    wget --no-check-certificate http://xrl.us/cpanm -O /usr/bin/cpanm
    chmod 755 /usr/bin/cpanm
    cpanm Vimana
    # install some perl module
    cpanm WWW::Shorten::Bitly
    cpanm Data::Dumper
    cpanm XML::Simple
    cpanm Class::Date
    cpanm DBD::mysql

    # Python interface to MySQL
    aptitude -y install python-mysqldb
    # Install django-html in an HTML minifier
    pip install django-htmlmin

    # Converts XML to Python objects (https://github.com/stchris/untangle)
    pip install untangle

    # http://pythonhosted.org/gearman/index.html
    pip install gearman

    # https://github.com/seb-m/pyinotify
    pip install pyinotify

    # install Amazone Super S3 command line tool
    # ref: https://github.com/bloomreach/s4cmd
    pip install boto
    install_s4cmd

    # remove MTA service
    aptitude -y remove exim4

    # wbench. It benchmarks websites, YO!
    gem install wbench
}

desktop() {
    output "Install Desktop Packages."
    # install Ubuntu PPA
    add-apt-repository -y ppa:webupd8team/sublime-text-2
    add-apt-repository -y ppa:geany-dev/ppa
    add-apt-repository -y ppa:pidgin-developers/ppa
    add-apt-repository -y ppa:amsn-daily/ppa

    # Installer for Microsoft TrueType core fonts
    aptitude -y install ttf-mscorefonts-installer
    aptitude -y purge ttf-mscorefonts-installer ubuntu-restricted-extras

    # program tool: geany
    aptitude -y install geany

    # pidgin + msn-pecan
    aptitude -y install pidgin msn-pecan

    # aMSN
    # ref: https://launchpad.net/~amsn-daily/+archive/ppa
    aptitude -y install aMSN

    # filezilla
    aptitude -y install filezilla

    # PCMan
    aptitude -y install pcmanx-gtk2

    # graphical tool to diff and merge files
    aptitude -y install meld

    # install java enviriment
    aptitude -y install sun-java6-jre sun-java6-plugin sun-java6-fonts

    # install adobe flash plugin
    aptitude -y install flashplugin-installer

    # install mp3 easytag
    aptitude -y install easytag

    # install mp3 player
    aptitude -y install exaile

    # install multiget (http://multiget.sourceforge.net/)
    aptitude -y install multiget

    # install 7zip
    aptitude -y install p7zip-full

    # install smplayer
    aptitude -y install smplayer

    # install hime (http://hime.luna.com.tw/)
    aptitude -y install hime im-config

    # install gcin
    aptitude -y install gcin
    # install gcin library
    aptitude -y gcin-chewing
    aptitude -y gcin-anthy
    # http://ahhafree.blogspot.tw/2011/11/gcin.html
    gsettings set com.canonical.Unity.Panel systray-whitelist "['all']"

    # install google chrome browser
    aptitude -y install google-chrome-stable

    # install sublime-text editor
    aptitude -y install sublime-text

    # Shutter is a feature-rich screenshot program.
    # ref: http://shutter-project.org/
    aptitude -y install shutter
}

clean-kernel() {
    output "Cleaning old Kernel source."
    # update all software
    aptitude -y update
    aptitude -y upgrade
    dpkg -l 'linux-*' | sed '/^ii/!d;/'"$(uname -r | sed "s/\(.*\)-\([^0-9]\+\)/\1/")"'/d;s/^[^ ]* [^ ]* \([^ ]*\).*/\1/;/[0-9]/!d' | xargs aptitude -y purge
}

# Process command line...
while [ $# -gt 0 ]; do
    case $1 in
        --help | -h)
            usage $0
        ;;
        --install | -i)
            shift
            action=$1
            shift
            ;;
        *)
            usage $0
            ;;
    esac
done

if [ "`whoami`" != "root" ] ; then
    displayErr "You are not root, please execute sudo su - command"
fi

test -z $action && usage $0

case $action in
    "clean-kernel")
        clean-kernel
        ;;
    "desktop")
        initial
        desktop
        ;;
    "server")
        initial
        server
        ;;
    "initial")
        initial
        ;;
    "mariadb")
        install_mariadb
        ;;
    "percona")
        install_percona
        ;;
    "nginx-spdy")
        install_nginx_spdy
        ;;
    "nginx")
        install_nginx
        ;;
    "mosh")
        install_mosh
        ;;
    "gearman")
        install_gearmand
        ;;
    "jenkins")
        install_jenkins
        ;;
    "timezone")
        install_timezone
        ;;
    "s4cmd")
        install_s4cmd
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
exit 1;
