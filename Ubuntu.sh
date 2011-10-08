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
#
################################################################################

# install and upgrade Ubuntu
apt-get update
apt-get -y install openssh-server
apt-get -y install vim
apt-get -y upgrade
apt-get -y install build-essential
apt-get -y install git
apt-get -y install subversion
apt-get -y install bison
apt-get -y install flex
apt-get -y install gettext
apt-get -y install g++
apt-get -y install libncurses5-dev
apt-get -y install libncursesw5-dev
apt-get -y install exuberant-ctags
apt-get -y install sharutils
apt-get -y install help2man
apt-get -y install zlib1g-dev libssl-dev
# for samba 3.0.2
apt-get -y install gawk
# for Ralink
apt-get -y install libid3tag0-dev
apt-get -y install libgdbm-dev
apt-get -y install xinetd nfs-kernel-server minicom build-essential libncurses5-dev uboot-mkimage autoconf automake
apt-get -y install qt4-make

# git core
apt-get -y install git-core git-doc git-gui

# terminal-based package manager (terminal interface only)
apt-get -y install aptitude

# Installer for Microsoft TrueType core fonts
apt-get -y install ttf-mscorefonts-installer
aptitude -y purge ttf-mscorefonts-installer ubuntu-restricted-extras

# firefox upgrade 4.0
add-apt-repository ppa:mozillateam/firefox-stable
apt-get -y update && apt-get -y upgrade

# lazyscripts
add-apt-repository ppa:lazyscripts/stable
apt-get -y update && apt-get -y install lazyscripts

# program tool: geany
add-apt-repository ppa:geany-dev/ppa
apt-get -y install geany

# pidgin + msn-pecan
# ref: https://launchpad.net/~pidgin-developers/+archive/ppa/
add-apt-repository ppa:pidgin-developers/ppa
apt-get -y install pidgin msn-pecan

# aMSN
# ref: https://launchpad.net/~amsn-daily/+archive/ppa
add-apt-repository ppa:amsn-daily/ppa
apt-get -y install aMSN

# filezilla 
apt-get -y install filezilla

# vim
apt-get -y install vim

# PCMan
apt-get -y install pcmanx-gtk2

# apache mpm worker mod_fcgid
apt-get -y install apache2.2-bin apache2.2-common apache2-mpm-worker libapache2-mod-fcgid php5-cli php5-cgi php5-common
apt-get -y install apache2 php5 php5-gd php5-curl

# man program
apt-get -y install most

# version tool: subversion program
apt-get -y install subversion

# grep-like program specifically for large source trees
apt-get -y install ack-grep

# graphical tool to diff and merge files
apt-get -y install meld

# install git from kernel git://git.kernel.org/pub/scm/git/git.git
apt-get -y install libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev

# install java enviriment
apt-get -y install sun-java6-jre sun-java6-plugin sun-java6-fonts

# install adobe flash plugin
apt-get -y install adobe-flashplugin

# install cpanm before install Vimana
wget --no-check-certificate http://xrl.us/cpanm -O /usr/bin/cpanm
chmod 755 /usr/bin/cpanm
cpanm Vimana

# install ruby
apt-get -y install ruby rake rubygems

# install mercurial
apt-get -y install mercurial

# install ffmpeg
apt-get -y install ffmpeg

# install irssi
apt-get -y install irssi

# install irc chat (XChat)
apt-get -y install xchat

# install python easy_install
apt-get -y install python-pip
