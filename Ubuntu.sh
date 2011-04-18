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





