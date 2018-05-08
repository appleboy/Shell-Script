#!/usr/bin/env bash

# install some command
which aptitude || apt-get -qqy install aptitude
aptitude -y update && aptitude -y install make git libncurses5-dev

# fetch dotfiles and script
cd ~ && git clone https://github.com/appleboy/dotfiles.git
cd ~/dotfiles && /bin/bash -c "source bootstrap.sh"
cd ~ && git clone https://github.com/appleboy/Shell-Script.git

echo
echo "Install Completely!!"
echo
