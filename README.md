## Simple CF Client

A simple example of using the [Cloud Foundry Java Client](https://github.com/cloudfoundry/cf-java-client) to access Stackato. 
After installing the Stackato self-signed certificate to the Java keystore, the client connects to Stackato and calls a handful 
of methods to show the spaces, apps, and services.


### Quick Start

The fastest way to get this running is with docker:

```bash
git clone https://github.com/bcferrycoder/cflab  
cd cflab; docker built -t cflab .
docker run cflab
```
By default this targets an exising Stackato instance on HPCloud. Here's the output:

```
$ docker run cflab

Targeting Stackato instance https://api.15.126.220.84.xip.io as user stackato

Spaces:
stackato:stackato

Applications:
jenkins
hello-java

Services
jenkins-fs:filesystem
hello-java-debug:harbor

```


You can target your own Stackato instance by changing the "docker run" command:

```bash
  docker run cflab -e  STACKATO_HOST=api.stackato-abcd.local -e STACKATO_USER=myusername -e STACKATO_PW=mypw
```

## Details

Read on if you want to understand what's going on under the hood. All requirements and steps are 
encapsulated in the Dockerfile.



### Java Code

The Java app in https://github.com/bcferrycoder/cflab/blob/master/src/main/java/com/bcferrycoder/cflab/SimpleCFClient.java 
makes a handful of CF client calls to authenticate and print the provisioned Spaces, Apps, and Services.


```java
        CloudCredentials credentials = new CloudCredentials(user, password);
        CloudFoundryClient client = new CloudFoundryClient(credentials, getTargetURL(target));
        client.login();

        System.out.println("\nSpaces:");
        for (CloudSpace space : client.getSpaces()) {
            System.out.println(space.getName() + ":" + space.getOrganization().getName());
        }

        System.out.println("\nApplications:");
        for (CloudApplication app : client.getApplications()) {
            System.out.println(app.getName());
        }

        System.out.println("\nServices");
        for (CloudService service : client.getServices()) {
            System.out.println(service.getName() + ":" + service.getLabel());
        }
    }
```

### Requirements

  * java
  * mvn


### Setup
  
1. Clone this repo:

```bash
       git clone https://github.com/bcferrycoder/cflab.git
```
       

2. Update the arguments in cflab/pom.xml to point to your Stackato instance:

```XML
           <!-- stackato url -->
           <argument>https://api.stackato-m6dw.local</argument>
           <!-- stackato username -->
           <argument>stackato</argument>
           <!-- stackato password -->
           <argument>stackato</argument>
```

3. Build

```bash
      mvn clean package
```

4. Run the sample app

```bash
      mvn exec:java
```

### Notes

This will fail (by design) unless Stackato's self-signed cert is installed in the local Java keystore.

To fix this:

1. Obtain the Stackato cert:

```bash
      openssl s_client -showcerts -connect stackato-kr5b.local:443 </dev/null
```

This will display the certificate along with a bunch of other
stuff. The certificate is right at the beginning.

-----BEGIN CERTIFICATE-----
MIIDrTCCApWgAwIBAgIJAJD0vTg7jOiCMA0GCSqGSIb3DQEBBQUAMG0xCzAJBgNV
BAYTAkNBMSswKQYJKoZIhvcNAQkBFhxzdGFja2F0b0BzdGFja2F0by1rcjViLmxv
wWL7jWsMcqDkH+zL5tGt6bi0pi424UEYa5lCEa9Y52PVyWQ00urkxVcWaysB32Tt
mOPc0+UvFThjTTgTmzPoAbLW7GigSVUHfpbRlnYoYh2a
-----END CERTIFICATE-----

Copy/paste the certificate to a file, say "/tmp/stackato-xxxx.local"

2. Now import the cert to the Java keystore. On my Mac, here's how I did it:

```bash
   sudo keytool -import -file /tmp/stackato-xxxx.local -alias stackato-xxxx -storepass changeit -keystore /System/Library/Frameworks/JavaVM.framework/Home/lib/security/cacerts
```



3. Try running the app again with **mvn exec:java**.  It should now print something like this:

    Spaces:
    stackato:stackato

    Applications:
    jenkins

    Services
    jenkins-fs:filesystem

