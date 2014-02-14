# Dockerfile to create a machine with 
# - basic linux functions (curl,wget,python, etc)
# - Lastest JDK installed
# - maven
# - sample Cloud Foundry client app

FROM ubuntu:latest

# Update the APT cache
RUN sed 's/main$/main universe/' /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

# Install and setup project dependencies
RUN apt-get install -y curl wget
RUN locale-gen en_US en_US.UTF-8

#prepare for Java download
RUN apt-get install -y python-software-properties
RUN apt-get install -y software-properties-common

#grab oracle java (auto accept licence)
RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get update
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get install -y oracle-java7-installer

# git
RUN apt-get install -y git-core

# mvn
# (The debian package sucks massively, so download directly)
RUN cd /tmp; wget http://mirror.gopotato.co.uk/apache/maven/maven-3/3.0.5/binaries/apache-maven-3.0.5-bin.tar.gz
RUN cd /opt; tar -xzf /tmp/apache-maven-3.0.5-bin.tar.gz; mv apache-maven-3.0.5 maven; ln -s /opt/maven/bin/mvn /usr/local/bin; rm -rf /tmp/*

RUN git clone https://github.com/bcferrycoder/cflab.git /cflab
RUN cd /cflab; mvn clean package

# override these with 'docker run -e STACKATO_HOST=mystackato.local -e STACKATO_USER=myuser -e STACKATO_PW=mypw'
ENV STACKATO_HOST api.15.126.220.84.xip.io
ENV STACKATO_USER stackato
ENV STACKATO_PW stackato

ADD runclient.sh /runclient.sh

ENTRYPOINT sh -x /runclient.sh
