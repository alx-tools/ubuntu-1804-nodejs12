FROM ubuntu:18.04
MAINTAINER Alexa Orrico <alexa.orrico@holbertonschool.com>

RUN apt-get update
RUN apt-get -y upgrade
# curl/wget/git
RUN apt-get install -y curl wget git tar
# vim/emacs
RUN apt-get install -y vim emacs
# C
RUN apt-get install -y build-essential gcc

# Set the locale
RUN apt-get install -y locales
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Node 12
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
RUN curl -sl https://deb.nodesource.com/setup_12.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt-get update && apt-get install -y nodejs

RUN mkdir /tmp/node_packages
COPY package.json /tmp/node_packages/package.json
RUN cd /tmp/node_packages && npm install

RUN mkdir /tmp/node_packages_615
COPY package_615.json /tmp/node_packages_615/package.json
RUN cd /tmp/node_packages_615 && npm install

# Man
RUN apt-get -y install man manpages-dev manpages-posix-dev
RUN yes | unminimize

# SSH
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd

RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/^#PasswordAuthentication/PasswordAuthentication/' /etc/ssh/sshd_config
RUN sed -ri 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

RUN sed -i 's/# set bell-style none/set bell-style none/g' /etc/inputrc

ADD run.sh /etc/sandbox_run.sh
RUN chmod u+x /etc/sandbox_run.sh

# start run!
CMD ["./etc/sandbox_run.sh"]
