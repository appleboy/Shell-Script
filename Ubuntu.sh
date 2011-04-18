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
apt-get install git-core git-doc git-gui

# terminal-based package manager (terminal interface only)
apt-get install aptitude

# Installer for Microsoft TrueType core fonts
apt-get install ttf-mscorefonts-installer
aptitude purge ttf-mscorefonts-installer ubuntu-restricted-extras

# firefox upgrade 4.0
add-apt-repository ppa:mozillateam/firefox-stable
apt-get update && apt-get upgrade

# lazyscripts
add-apt-repository ppa:lazyscripts/stable
apt-get update && apt-get install lazyscripts

# program tool: geany
add-apt-repository ppa:geany-dev/ppa
apt-get install geany

# pidgin
apt-get install pidgin

# filezilla 
apt-get install filezilla

# vim
apt-get install vim

# PCMan
apt-get install pcmanx-gtk2

# apache mpm worker mod_fcgid
apt-get install apache2.2-bin apache2.2-common apache2-mpm-worker libapache2-mod-fcgid php5-cli php5-cgi php5-common
apt-get install apache2 php5 php5-gd php5-curl

# man program
apt-get install most

# version tool: subversion program
apt-get install subversion





