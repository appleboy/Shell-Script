#!/usr/local/bin/bash
###############################################
#
# Date:     2011.03.14
# Author:   appleboy ( appleboy.tw AT gmail.com)
# Web:      http://blog.wu-boy.com
# Ref:      http://www.freebsd.org/doc/en/books/porters-handbook/plist-autoplist.html
#
###############################################

PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin
export PATH

function displayErr()
{
    echo $1;
    exit 1;
}

function usage()
{
    echo 'Usage: '$0' Source_Dir Target_Dir'
    exit 1;
}

if [ "$#" -lt "2" ]; then
    usage $0
fi

#
# configure system parameters
#

HOME=$1
TARGET=$2
TMPDIR="/var/tmp"

#
# configure end
#

[ ! -d "$HOME" ] && displayErr "${HOME} is not directory"

if [ ! -d "$TARGET" ]; then
    echo "$TARGET directory will be created"
    mkdir -p $TARGET
fi

#
# clean ports file

cd $HOME && make clean

#
# get port name 

PORTNAME=$(make -V PORTNAME)

#
# Before create port directory, please delete it.
# Next, create a temporary directory tree into which your port can be installed, and install any dependencies.
rm -rf ${TMPDIR}/${PORTNAME}
if [ ! -d "${TMPDIR}/${PORTNAME}" ]; then
    echo "${TMPDIR}/${PORTNAME} will be created"
    mkdir -p ${TMPDIR}/${PORTNAME}
fi

mtree -U -f $(make -V MTREE_FILE) -d -e -p ${TMPDIR}/${PORTNAME}
make depends PREFIX=${TMPDIR}/$PORTNAME

#
# Store the directory structure in a new file.

cd ${TMPDIR}/${PORTNAME} && find -d * -type d | sort > ${TARGET}/OLD-DIRS
#
# If your port honors PREFIX (which it should) you can then install the port and create the package list.

cd $HOME && make install PREFIX=${TMPDIR}/${PORTNAME}
cd ${TMPDIR}/${PORTNAME} && find -d * \! -type d | sort > ${TARGET}/pkg-plist

#
# You must also add any newly created directories to the packing list.

cd ${TMPDIR}/${PORTNAME} && find -d * -type d | sort | comm -13 ${TARGET}/OLD-DIRS - | sort -r | sed -e 's#^#@dirrm #' >> ${TARGET}/pkg-plist

echo "Please check  ${TARGET}/pkg-plist file"

