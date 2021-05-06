# A Docker recipe that runs Pegasus and HTCondor and targets ISI Donut as the execution site

This project prepares a Docker container that can run on your local machine and submit Pegasus workflows **remotely**, using HTCondor BOSCO, to Donut.

The container can be found at https://hub.docker.com/r/pegasus/donut-remote-submission.

New versions of the container will be tagged with the version of Pegasus installed in the image (e.g., pegasus/donut-remote-submission:pegasus-5.0.0).

## Basic scripts and files

**Docker/Dockerfile** Dockerfile used to prepare a container with Pegasus and HTCondor BOSCO, ommiting Pegasus' R support.

**docker-compose.yml** A Docker Compose file to automate the instantiation of the container.

**data/config/donut.conf** Contains envuironmental variables that are relevant for your account at Donut.

**data/helpers/initialize-donut.sh** This script initializes your Donut home to accept jobs using the HTCondor BOSCO method. It installs Pegasus and installs the BOSCO binaries under your account.

**data/workflows** This fodler contains Pegasus 5.0 workflow examples that can be submitted directly to Donut. You can use this folder to create your workflows too.

## Prerequisites

- Install Docker on your local machine (https://docs.docker.com/get-docker/)
- Install Docker Compose on your local machine (https://docs.docker.com/compose/install/)

Step 1a: Create a new ssh key for DONUT
--------------------------------------
```
cd data/.ssh
ssh-keygen -b 4096 -f bosco_key.rsa
```

Step 1b: If you added a password to the new key
-----------------------------------------------
Paste the password in data/.bosco/.pass

Step 1c: Add the public key to the DONUT Cluster
------------------------------------------------
Paste a new line with your public key in ~/.ssh/authorized\_keys on donut-submit01.

Step 2: Update data/config/donut.conf
-------------------------------------
In data/config/donut.conf update the section "ENV Variables For DONUT" with your information.

More specifically replace:
- **DONUT\_USER**, with your user name on DONUT
- **DONUT\_USER\_HOME**, with your user home directory on DONUT

Step 3: Start the Docker container
----------------------------------

```
docker-compose up -d
```

Step 4: Get an interactive shell to the container
-------------------------------------------------
```
docker exec -it pegasus-donut /bin/bash
```

Step 4: Run the initialization script
--------------------------------------
This is required only once, the first time you bring up the container, or if you want to update the Pegasus version installed on Donut.
```
/home/pegasus/helpers/initialize-donut.sh
```

Step 5: Run a workflow
----------------------

```
cd /home/pegasus/workflows/diamond-workflow
./workflow_generator.py
./plan.sh workflow.yml
```

Deleting the Docker container
-----------------------------

```
docker-compose down
```
