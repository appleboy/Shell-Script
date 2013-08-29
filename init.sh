#!/bin/sh

# install some command
aptitude -y install make git

# fetch dotfiles and script
cd ~ && git clone https://github.com/appleboy/dotfiles.git
cd ~/dotfiles && make linux
source ~/.bashrc
cd ~ && git clone https://github.com/appleboy/Shell-Script.git

echo
echo "Install Completely!!"
echo