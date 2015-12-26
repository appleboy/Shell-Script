# This is a comment
FROM gliderlabs/alpine:3.3

MAINTAINER Bo-Yi Wu <appleboy.tw@gmail.com>

RUN apk --update add bash git rsync
RUN cd ~ && git clone https://github.com/appleboy/dotfiles.git
RUN chmod 755 /root/dotfiles/bootstrap.sh
RUN /root/dotfiles/bootstrap.sh -f
