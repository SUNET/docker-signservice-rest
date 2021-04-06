
---
# CURRENT BUILD VERSION = 1.0.0 (not yet released)
---
# docker-signservice-rest

This repo contains build and deploy scripts for the SUNET SignService Integration REST Service.

The following build and deployment steps should be followed:

1. Using the pre-build docker image
2. Building a docker image
3. Setting up key files and configuration data.
4. Deploying the docker image as docker container.

The REST-service application is provided as a Spring Boot application, and it is deployed to Maven central at https://repo1.maven.org/maven2/se/idsec/signservice/integration/signservice-integration-rest.

## 1. Using the pre-built docker image

```
bash
# docker pull docker.sunet.se/signservice-integration-rest:<version>
```

## 2. Building Docker file

The docker build script "build.sh" builds a docker image for the integration service application by performing the following actions:

- Downloading the executable .jar file from maven repository.
- Downloading the signature (asc) on the metadata validator executable.
- Verifying the signature on the downloaded .jar file.
- Building the docker image.

```
Usage: build.sh [options...]

   -v, --version          Version for artifact to download
   -i, --image            Name of image to create (default is signservice-integration-rest)
   -t, --tag              Optional docker tag for image
   -c, --clear            Clears the target directory after a successful build (default is to keep it)
   -h, --help             Prints this help
```

There is a Makefile in the directory that simplifies the build. Just run 'make'.

## 3. Configuration

The resources folder contains sample configuration data. The content of the `resources` folder illustrates a working example file structure to be placed in a directory specified in a suitable location reflected in the settings of the `application.properties` file in combination with the environment variable `SPRING_CONFIG_ADDITIONAL_LOCATION`.

> Note: The `SPRING_CONFIG_ADDITIONAL_LOCATION` MUST be set to a directory name and MUST end with a trailing '/'.

The following folders and files are present in `resources`:

| Folder | Description |
| :--- | :--- |
| `keys` | Keystores and certificates for the application. |
| `pdf` | PDF signature files and PDF signature images. |


The following files are present in the base directory:

| File | Description |
| :--- | :--- |
| `application.properties` | Main configuration file. |
| `policy-configuration.properties` | Signature policy configuration. |
| `signservice-users.properties` | User configuration. |


See the [signservice-integration-rest](https://github.com/idsec-solutions/signservice-integration-rest) repository for a full description of how to configure the service.


## 3. Running the docker container

The samples folder contains a sample docker deploy script `deploy.sh`:

```
#!/bin/bash

echo Deploying docker containter signservice-integration-rest
docker run -d --name signservice-integration-rest --restart=always \
  -p 8080:8080 -p 8009:8009 \
  -e "SPRING_CONFIG_ADDITIONAL_LOCATION=/opt/signservice-integration-rest/" \
  -v /etc/localtime:/etc/localtime:ro \
  -v /opt/docker/signservice-integration-rest:/opt/signservice-integration-rest \
  signservice-integration-rest

echo Done!
```

Use of HTTP, HTTPS and AJP access to the service is specified in `application.properties`. The `Dockerfile` is reflecting this by currently exposing port 8080, 8443 and 8009.

The environment variable `SPRING_CONFIG_ADDITIONAL_LOCATION`, specifies the location where the configuration folder is located. Note that the specified location must end with a "/" character.

All property values in application.properties can be overridden by docker run environment variable settings. The convention is to specify the property name in uppercase letters and replace "." and "-" characters with underscore ("\_").
