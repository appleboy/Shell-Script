#!/usr/bin/env bash

# install some command
which aptitude || apt-get -qqy install aptitude
aptitude update && aptitude -y install make git

# fetch dotfiles and script
cd ~ && git clone https://github.com/appleboy/dotfiles.git
cd ~/dotfiles && /bin/bash -c "source bootstrap.sh"
cd ~ && git clone https://github.com/appleboy/Shell-Script.git

echo
echo "Install Completely!!"
echo
