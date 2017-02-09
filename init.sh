#!/bin/sh

alias brc='source bootstrap.sh'

# install some command
which aptitude || apt-get -qqy install aptitude
aptitude -y install make git

# fetch dotfiles and script
cd ~ && git clone https://github.com/appleboy/dotfiles.git
cd ~/dotfiles && brc
cd ~ && git clone https://github.com/appleboy/Shell-Script.git

echo
echo "Install Completely!!"
echo
