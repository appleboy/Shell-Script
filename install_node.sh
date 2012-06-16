#!/bin/bash
######################################################
# Date:     2011/10/28
# Author:   appleboy ( appleboy.tw AT gmail.com)
# Web:      http://blog.wu-boy.com
#
# Program:
#   Install node.js and npm tool
#
# History:
#   2011/10/28 (first release)
#
######################################################

function displayErr()
{
    echo $1;
    exit 1;
}

function usage()
{
    echo 'Usage: '$0' version(0.6.19)'
    exit 1;
}

if [ "$#" -lt "1" ]; then
    usage $0
fi

node_version=$1

[ ! -e $PWD ] && $PWD=`pwd`
TARGET="${PWD}/$1"

#
# check target dir

([ -d "$TARGET" ] || [ -f "$TARGET" ]) && displayErr "${TARGET} is exist, please remove it first."

echo "$TARGET directory will be created"
mkdir -p $TARGET

#
# download node.js source

wget "http://nodejs.org/dist/node-v${node_version}.tar.gz" -O node.tar.gz
[ ! -f node.tar.gz ] && displayErr "no such file node.tar.gz!"
tar -zxvf node.tar.gz

# install nodejs
cd "node-v${node_version}/" && ./configure --prefix="${TARGET}/node" && make && make install && cd -

# modified bashrc
echo "export NODE_PATH=${TARGET}/node:${TARGET}/node/lib/node_modules" >> ~/.bashrc # ~/.bash_profile or ~/.bashrc on some systems
echo "export PATH=$PATH:${TARGET}/node/bin" >> ~/.bashrc # ~/.bash_profile or ~/.bashrc on some systems

source ~/.bashrc

# install npm
curl http://npmjs.org/install.sh | sh

#
# remove source
rm -rf node.tar.gz node-v0.4.12

#
# Install completely
echo
echo "Install Completely!!!!"
echo
echo "#################################"
echo
echo "node path: ${TARGET}/node/bin/node"
echo "npm path: ${TARGET}/node/bin/npm"
echo
echo "#################################"
