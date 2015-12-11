# This is a comment
FROM ubuntu:14.04

MAINTAINER Bo-Yi Wu <appleboy.tw@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -qq update
RUN apt-get -qqy install wget
RUN wget -qO- https://raw.github.com/appleboy/Shell-Script/master/init.sh | sh
