# A Docker recipe that runs Pegasus and HTCondor and targets ISI Donut as the execution site

This project prepares a Docker container that can run on your local machine and submit Pegasus workflows **remotely**, using HTCondor BOSCO, to Donut.

The container should be built on the host machine so the user account within the container matches your local user id and group id.
This is important for the volume mounts to work properly.

If you would like to retrieve a default image that doesn't necessarily match the owner of the files on your local file system, please check https://hub.docker.com/r/pegasus/donut-remote-submission.
New versions of the container will be tagged with the version of Pegasus installed in the image (e.g., pegasus/donut-remote-submission:pegasus-5.0.0).

## Basic scripts and files

**Docker/image.conf** This file contains configuration variables for the build of the image and for its invocation.

**Docker/Dockerfile** Dockerfile used to prepare a container with Pegasus and HTCondor BOSCO, ommiting Pegasus' R support.

**Docker/docker_build.sh** A wrapper script that builds an image for your local user. The image will be named after your local user and will be tagged with the version of Pegasus specified in Docker/image.conf.

**docker-compose.yml** A Docker Compose file to automate the instantiation of the container.

**docker_run.sh** A wrapper script that starts the container using docker-compose, after sourcing the configuration from Docker/image.conf

**docker_stop.sh** A wrapper script that stops the running container using docker-compose, after sourcing the configuration from Docker/image.conf

**data/config/donut.conf** Contains envuironmental variables that are relevant for your account at Donut.

**data/helpers/initialize-donut.sh** This script initializes your Donut home to accept jobs using the HTCondor BOSCO method. It installs Pegasus and installs the BOSCO binaries under your account.

**data/workflows** This fodler contains Pegasus 5.0 workflow examples that can be submitted directly to Donut. You can use this folder to create your workflows too.

## Prerequisites

- Install Docker on your local machine (https://docs.docker.com/get-docker/)
- Install Docker Compose on your local machine (https://docs.docker.com/compose/install/)

Step 1: Update Docker/image.conf
-------------------------------------------
Update Docker/image.conf with the version of Pegasus you prefer.
Currently I suggest using 5.1.0panorama since it contains some changes for GPU submission on Donut.

More specifically replace:
- **PEGASUS_VERSION_NUM**, with the pegasus version number (e.g., 5.1.0.panorama)

Step 2: Build a new docker image using the recipe
-------------------------------------------------
```
cd Docker
./docker_build.sh
```

Step 3: Create a new ssh key for DONUT
---------------------------------------
Adding a passphrase will require more advanced configuration, not covered in this README.

```
cd data/.ssh
ssh-keygen -b 4096 -f bosco_key.rsa
```

Step 4: Add the public key to the DONUT Cluster
------------------------------------------------
Paste a new line with your public key in ~/.ssh/authorized\_keys on donut-submit01.

Step 5: Update data/config/donut.conf
-------------------------------------
In data/config/donut.conf update the section "ENV Variables For DONUT" with your information.

More specifically replace:
- **DONUT\_USER**, with your user name on DONUT
- **DONUT\_USER\_HOME**, with your user home directory on DONUT

Step 6: Start the Docker container
----------------------------------

```
./docker_run.sh
```

Step 7: Get an interactive shell to the container
-------------------------------------------------
```
docker exec -it pegasus-donut-LOCAL\_USER /bin/bash
```

Step 8: Run the initialization script
--------------------------------------
This is required only **once**, the first time you bring up the container, or if you want to update the Pegasus version installed on Donut.
```
/home/pegasus/helpers/initialize-donut.sh
```

Step 9: Run a workflow
----------------------

```
cd /home/pegasus/workflows/diamond-workflow
./workflow_generator.py
./plan.sh workflow.yml
```

Deleting the Docker container
-----------------------------

```
./docker_stop.sh
```
