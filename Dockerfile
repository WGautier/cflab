# docker build -t="jdw/cflab" .

FROM ubuntu:12.10
MAINTAINER John Wetherill "john.wetherill@bcferrycoder.com"

# java
run  apt-get update
run  apt-get install -q -y openjdk-6-jre-headless wget

# THIS IS FAILING DUE TO DOCKER PRIVILEGES
# mvn
#run apt-get install maven
