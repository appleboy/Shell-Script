#!/bin/bash
################################################################################
# Date:     2011/04/18
# Author:   appleboy ( appleboy.tw AT gmail.com)
# Web:      http://blog.wu-boy.com
#
# Program:
#   Install all Ubuntu program automatically
#
# History:
#   2011/04/18 (first release)
#   2011/09/03 add ffmpeg, irssi and xchat package
#   2011/10/08 add python easy install
#   2011/10/23 add mp3 player and easytag
#   2012/01/17 add terminal multiplexer
#   2012/02/24 add multiget
#   2012/06/16 add smplayer and remove some installer
#   2012/06/17 add mysql server, xdebug, ImageMagic, modified flash path, livereload, compass tool
#   2012/06/22 add gcin setting
#   2012/06/22 add google chrome browser
#   2012/06/29 add sublime-text editor
#
################################################################################

# install Ubuntu PPA
add-apt-repository -y ppa:webupd8team/sublime-text-2
add-apt-repository -y ppa:geany-dev/ppa
add-apt-repository -y ppa:pidgin-developers/ppa
add-apt-repository -y ppa:amsn-daily/ppa

# update package and upgrade Ubuntu
apt-get -y update && apt-get -y upgrade
# terminal-based package manager (terminal interface only)
apt-get -y install aptitude

aptitude -y install openssh-server
aptitude -y install build-essential
aptitude -y install git
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
# for samba 3.0.2
aptitude -y install gawk
# for Ralink
aptitude -y install libid3tag0-dev
aptitude -y install libgdbm-dev
aptitude -y install xinetd nfs-kernel-server minicom build-essential libncurses5-dev uboot-mkimage autoconf automake
aptitude -y install qt4-make

# terminal-based package manager (terminal interface only)
aptitude -y install aptitude

# git core
aptitude -y install git-core git-doc git-gui

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

# vim
aptitude -y install vim

# PCMan
aptitude -y install pcmanx-gtk2

# apache mpm worker mod_fcgid
aptitude -y install apache2.2-bin apache2.2-common apache2-mpm-worker libapache2-mod-fcgid php5-cli php5-cgi php5-common
aptitude -y install apache2 php5 php5-gd php5-curl

# php xdebug
aptitude -y install php5-dev
aptitude -y install php-pear
pecl install xdebug

# install mysql server and phpmyadmin
aptitude -y install mysql-server phpmyadmin

# man program
aptitude -y install most

# version tool: subversion program
aptitude -y install subversion

# grep-like program specifically for large source trees
aptitude -y install ack-grep

# graphical tool to diff and merge files
aptitude -y install meld

# install git from kernel git://git.kernel.org/pub/scm/git/git.git
aptitude -y install libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev

# install java enviriment
aptitude -y install sun-java6-jre sun-java6-plugin sun-java6-fonts

# install adobe flash plugin
aptitude -y install flashplugin-installer

# install cpanm before install Vimana
wget --no-check-certificate http://xrl.us/cpanm -O /usr/bin/cpanm
chmod 755 /usr/bin/cpanm
cpanm Vimana

# install ruby
aptitude -y install ruby rake rubygems

# install mercurial
aptitude -y install mercurial

# install ffmpeg
aptitude -y install ffmpeg

# install irssi
aptitude -y install irssi

# install irc chat (XChat)
aptitude -y install xchat

# install python easy_install
aptitude -y install python-pip

# install mp3 easytag
aptitude -y install easytag

# install terminal multiplexer (http://tmux.sourceforge.net/)
aptitude -y install tmux

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
# http://ahhafree.blogspot.tw/2011/11/gcin.html
gsettings set com.canonical.Unity.Panel systray-whitelist "['all']"

# install ImageMagic
aptitude -y install imagemagick

# update rubygems
gem install rubygems-update
update_rubygems

# install compass tool and livereload
gem install compass
gem install guard-livereload

# install google chrome browser
aptitude -y install google-chrome-stable

# install sublime-text editor
aptitude -y install sublime-text

# install PPA purge command
aptitude -y install ppa-purge
