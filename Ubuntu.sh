#!/bin/bash
################################################################################
# Date:     2011/04/18
# Author:   appleboy ( appleboy.tw AT gmail.com)
# Web:      http://blog.wu-boy.com
# modified: 2013/02/08
#
# Program:
#   Install all Ubuntu program automatically
#
# log:
#   2013.02.08 add MariaDB server
#   2013.02.06 add UglifyJS tool v1 and v2.
#   2013.01.19 add bower package
#   2013.01.08 add nvm tool, install coffee script, handlebars, RequireJS and express server
#   2012.10.13 add clean previous kernels function after update
#
################################################################################

function usage()
{
    echo 'Usage: '$0' [--help|-h] --install [clean-kernel|server|desktop|initial|all]'
    exit 1;
}

function displayErr()
{
    echo
    echo $1;
    echo
    exit 1;
}

function initial()
{
    # update package and upgrade Ubuntu
    apt-get -y update && apt-get -y upgrade
    # terminal-based package manager (terminal interface only)
    apt-get -y install aptitude
}

function install_mariadb()
{
    # get sever os name: ubuntu or debian
    server_name=`lsb_release -i | awk -F " " '{printf $3}' | tr A-Z a-z`
    version_name=`lsb_release -c | awk -F " " '{printf $2}' | tr A-Z a-z`
    aptitude -y install python-software-properties
    apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db
    # repository url ref: https://downloads.mariadb.org/mariadb/repositories/
    if [ "$server_name" == "debian" ] ; then
        echo "deb http://ftp.yz.yamagata-u.ac.jp/pub/dbms/mariadb/repo/5.5/${server_name} ${version_name} main" >> /etc/apt/sources.list
    else
        add-apt-repository "deb http://ftp.yz.yamagata-u.ac.jp/pub/dbms/mariadb/repo/5.5/${server_name} ${version_name} main"
    fi
    aptitude -y update
    aptitude -y install mariadb-server
}

function server()
{
    # install Ubuntu PPA
    add-apt-repository -y ppa:nginx/stable

    aptitude -y install openssh-server
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
    aptitude -y install qt4-make

    # install git from kernel git://git.kernel.org/pub/scm/git/git.git
    aptitude -y install libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev

    # git core and git flow command
    aptitude -y install git git-core git-doc git-gui git-flow

    # mkpasswd command
    aptitude -y install whois

    # vim
    aptitude -y install vim

    # apache mpm worker mod_fcgid
    aptitude -y install apache2.2-bin apache2.2-common apache2-mpm-worker libapache2-mod-fcgid php5-cli php5-cgi php5-common
    aptitude -y install apache2 php5 php5-gd php5-curl php5-fpm php5-xdebug php-apc php5-memcache

    # install nginx web server
    aptitude -y install nginx

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

    # install terminal multiplexer (http://tmux.sourceforge.net/)
    aptitude -y install tmux

    # install ImageMagic
    aptitude -y install imagemagick

    # update rubygems
    gem install rubygems-update
    update_rubygems

    # install compass tool and livereload
    gem install compass
    gem install guard-livereload

    # install PPA purge command
    aptitude -y install ppa-purge

    # install sshfs command
    aptitude -y install sshfs

    # remove nfs and rpcbind
    aptitude -y --purge remove nfs-common
    aptitude -y --purge remove rpcbind

    # Don't install rar and unrar together.
    # ref: http://yaohua.info/2012/05/19/ubuntu-extracting-rar-invalid-encoding/
    aptitude -y --purge remove rar
    aptitude -y install unrar

    # install nvm
    # https://github.com/creationix/nvm
    curl https://raw.github.com/appleboy/nvm/develop/install.sh | sh
    . ~/.nvm/nvm.sh
    nvm install stable
    nvm use stable

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

    # install PHP-CS-Fixer
    # https://github.com/fabpot/PHP-CS-Fixer
    wget http://cs.sensiolabs.org/get/php-cs-fixer.phar -O /usr/local/bin/php-cs-fixer
    chmod a+x /usr/local/bin/php-cs-fixer

    # Python interface to MySQL
    aptitude -y install python-mysqldb

    # install NySQL monitor
    aptitude -y install mytop

    # https://github.com/appleboy/MySQLTuner-perl
    wget https://raw.github.com/appleboy/MySQLTuner-perl/master/mysqltuner.pl -O /usr/local/bin/mysqltuner
    chmod a+x /usr/local/bin/mysqltuner

    # https://launchpad.net/mysql-tuning-primer
    wget https://launchpadlibrarian.net/78745738/tuning-primer.sh -O /usr/local/bin/tuning-primer
    chmod a+x /usr/local/bin/tuning-primer

    # install cpanm before install Vimana
    wget --no-check-certificate http://xrl.us/cpanm -O /usr/bin/cpanm
    chmod 755 /usr/bin/cpanm
    cpanm Vimana

    # install MariaDB server
    install_mariadb

    # install phpMyAdmin
    aptitude -y install phpmyadmin
}

function desktop()
{
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
}

function clean-kernel()
{
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
        --install) shift; action=$1; shift; ;;
        *) usage $0; ;;
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
    "install-db")
        install_mariadb
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
