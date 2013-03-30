#!/bin/bash
#
# This script checks if a mysql server is healthy running on localhost. It will
# return:
#
# "HTTP/1.x 200 OK\r" (if mysql is running smoothly)
#
# - OR -
#
# "HTTP/1.x 500 Internal Server Error\r" (else)
#
# The purpose of this script is make haproxy capable of monitoring mysql properly
#
# Author: Unai Rodriguez
#
# It is recommended that a low-privileged-mysql user is created to be used by
# this script. Something like this:
#
# mysql> GRANT SELECT on mysql.* TO 'mysqlchkusr'@'localhost' \
#     -> IDENTIFIED BY '257retfg2uysg218' WITH GRANT OPTION;
# mysql> flush privileges;
#
# Script modified by Alex Williams - August 4, 2009
#       - removed the need to write to a tmp file, instead store results in memory


MYSQL_HOST="127.0.0.1"
MYSQL_PORT="3306"
MYSQL_USERNAME="replication_user"
MYSQL_PASSWORD="replication_pass"

#
# We perform a simple query that should return a few results :-p

ERROR_MSG=`/usr/bin/mysql --host=$MYSQL_HOST --port=$MYSQL_PORT --user=$MYSQL_USERNAME --password=$MYSQL_PASSWORD -e "show databases;" 2>/dev/null`

#
# Check the output. If it is not empty then everything is fine and we return
# something. Else, we just do not return anything.
#
if [ "$ERROR_MSG" != "" ]
then
        # mysql is fine, return http 200
        /bin/echo -e "HTTP/1.1 200 OK\r\n"
        /bin/echo -e "Content-Type: Content-Type: text/plain\r\n"
        /bin/echo -e "\r\n"
        /bin/echo -e "MySQL is running.\r\n"
        /bin/echo -e "\r\n"
else
        # mysql is fine, return http 503
        /bin/echo -e "HTTP/1.1 503 Service Unavailable\r\n"
        /bin/echo -e "Content-Type: Content-Type: text/plain\r\n"
        /bin/echo -e "\r\n"
        /bin/echo -e "MySQL is *down*.\r\n"
        /bin/echo -e "\r\n"
fi