# docker build -t="jdw/cflab" .

FROM ubuntu:12.10
MAINTAINER John Wetherill "john.wetherill@bcferrycoder.com"

# java
run  apt-get update
run  apt-get install -q -y openjdk-6-jre-headless wget

# mvn
run apt-get install maven

# cloud foundry client
run https://github.com/cloudfoundry/cf-java-client.git

run mkdir -p cf-java-client/cf-java-client-test-apps/simple-spring-app/src/main/java/com/bcferrycoder/cflab
add config/SimpleCFClient.java cf-java-client/cf-java-client-test-apps/simple-spring-app/src/main/java/com/bcferrycoder/cflab/
