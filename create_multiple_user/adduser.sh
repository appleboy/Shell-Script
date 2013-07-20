#!/bin/bash
#################################################
# Date:     2013/07/19
# Author:   appleboy (appleboy.tw AT gmail.com)
# Web:      http://blog.wu-boy.com
#
# Program:
#   Add multiple user account via config file.
#
# History:
#   2013/07/19 first release
#
#################################################

cat config.txt | while read USER PASSWORD
do
    echo "Create user: ${USER}"
    create_user --action add ${USER} ${PASSWORD}
done

cat config.txt | while read USER PASSWORD
do
    echo "Delete user: ${USER}"
    create_user --action del ${USER} ${PASSWORD}
done
