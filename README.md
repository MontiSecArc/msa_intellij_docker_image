# About 
This project creates a docker image with a pre-installed IntelliJ IDEA 2017.1 instance. By utilizing docker IntelliJ IDEA with pre-installed MontiSecArc plugins can be distributed either for development purposes by using X11, for example, or by running headless IntelliJ IDEA instances in the docker image and therefore, providing a headless IntelliJ IDEA inspection server.

**Docker Hub Link:**

https://hub.docker.com/r/thomasbuning/msa_intellij_docker_image/

The docker image gets automatically build everytime a publish to the repository.

**Current Plugin Versions in Image**

- IntelliJ_Language_Plugin:  0.8.17
- GraphDatabasePlugin:       1.0.5


# Quickstart
The project has three parts:
1. Dockerfile
2. jdk.table.xml
3. pluginSetup

## Dockerfile
The Dockerfile contains all necessary commands to setup a Linux distribution inside the image and installs IntelliJ IDEA and all required plugins. The plugins are installed in the previously mentioned versions.

## jdk.table.xml
This XML file adds a Java JRE to the installed IntelliJ IDEA instance.

## pluginSetup
This script installs the plugins if this didn't happen before.

# Create New Image
Creating a new image has to be triggered by pushing to the GitHub repository which currently can only be done by @thomas.buning 
