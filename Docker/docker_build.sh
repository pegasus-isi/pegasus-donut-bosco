#!/usr/bin/env bash

source image.conf

docker build --no-cache \
             --build-arg PEGASUS_UID=${PEGASUS_UID} \
             --build-arg PEGASUS_GID=${PEGASUS_GID} \
             --build-arg PEGASUS_VERSION_NUM=${PEGASUS_VERSION_NUM} \
             --tag ${LOCAL_USER}/donut-remote-submission:pegasus-${PEGASUS_VERSION_NUM} \
             -f Dockerfile .
