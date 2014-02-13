# Create container to run CloudFoundry Java client
FROM ubuntu:precise
MAINTAINER John Wetherill <jdw@bcferrycoder.com>

## DEPENDENCIES ##
RUN apt-get update && apt-get install --assume-yes python-software-properties curl default-jdk

# install maven from a PPA, it doesn't seem to be in the Docker Ubuntu distro.
RUN add-apt-repository ppa:natecarlson/maven3
RUN apt-get update && apt-get install --assume-yes maven3

