package com.bcferrycoder.cflab;

/**
 * Created by IntelliJ IDEA.
 * User: jdw
 * Date: 2/11/14
 * Time: 1:20 PM
 * Copyright 2012 Glen Canyon Corporation
 */

import org.cloudfoundry.client.lib.CloudCredentials;
import org.cloudfoundry.client.lib.CloudFoundryClient;
import org.cloudfoundry.client.lib.domain.CloudApplication;
import org.cloudfoundry.client.lib.domain.CloudService;
import org.cloudfoundry.client.lib.domain.CloudSpace;
import org.cloudfoundry.client.lib.domain.Staging;

import javax.net.ssl.*;
import java.io.File;
import java.net.URI;
import java.net.URL;
import java.security.cert.X509Certificate;
import java.util.ArrayList;
import java.util.List;

public class SimpleCFClient {
    public static void main(String[] args) throws Exception {


        String targetName = args[0];
        if (targetName == null || targetName.equals("noop")) {
            System.exit(0);
        }
        String target = "https://api." + targetName;
        String user = args[1];
        String password = args[2];
        String organization = args[3];
        String cloudSpace = args[4];
        String warPath = "hello-java-1.0.war";

        CloudCredentials credentials = new CloudCredentials(user, password);
        CloudFoundryClient client = new CloudFoundryClient(credentials, getTargetURL(target), organization, cloudSpace);
        client.login();

        System.out.println("\nTargeting Stackato instance " + target + " as user " + user);

        System.out.println("\nSpaces:");
        for (CloudSpace space : client.getSpaces()) {
            System.out.println(space.getName() + ":" + space.getOrganization().getName());
        }

        System.out.println("\nApplications:");
        for (CloudApplication app : client.getApplications()) {
            System.out.println(app.getName());
        }

        System.out.println("\nServices:");
        for (CloudService service : client.getServices()) {
            System.out.println(service.getName() + ":" + service.getLabel());
        }
        System.out.println("\n");

        String appName = "hello-java-cflab";
        List<CloudApplication> existingApps = client.getApplications();
        boolean found = false;
        for (CloudApplication existingApp : existingApps) {
            if (existingApp.getName().equals(appName)) {
                found = true;
                break;
            }
        }
        if (found) {
            System.out.println("\nApp " + appName + " already exists, skipping creation.");
        } else {
            System.out.println("\nCreating new app " + appName);
            Staging staging = new Staging();
            List<String> uris = new ArrayList<String>();
            uris.add(appName + "." + targetName);
            List<String> services = new ArrayList<String>();
            client.createApplication(appName, staging, 512, uris, services);
        }

        System.out.println("\nUploading app " + appName);
        File warFile = new File(warPath);
        client.uploadApplication(appName, warFile);
    }

    private static URL getTargetURL(String target) {
        try {
            return new URI(target).toURL();
        } catch (Exception e) {
            System.out.println("The target URL is not valid: " + e.getMessage());
        }
        System.exit(1);
        return null;
    }
}
