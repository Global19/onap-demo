#!/bin/bash

# Establish environment variables
NEXUS_USERNAME=$(cat /opt/config/nexus_username.txt)
NEXUS_PASSWD=$(cat /opt/config/nexus_password.txt)
NEXUS_DOCKER_REPO=$(cat /opt/config/nexus_docker_repo.txt)
DOCKER_IMAGE_VERSION=$(cat /opt/config/mvim_docker.txt)

source /opt/config/onap_ips.txt

# Refresh images
docker login -u $NEXUS_USERNAME -p $NEXUS_PASSWD $NEXUS_DOCKER_REPO
docker pull $NEXUS_DOCKER_REPO/onap/multicloud/framework:$DOCKER_IMAGE_VERSION
docker pull $NEXUS_DOCKER_REPO/onap/multicloud/vio:$DOCKER_IMAGE_VERSION

docker rm -f multicloud-broker
docker rm -f multicloud-vio

docker run -e MS_ADDR=$OPENO_IP -e AAI_ADDR=$AAI_IP1 -p 9001:9001 --name multicloud-broker $NEXUS_DOCKER_REPO/onap/multicloud/framework:$DOCKER_IMAGE_VERSION
docker run -e MS_ADDR=$OPENO_IP -e AAI_ADDR=$AAI_IP1 -p 9004:9004 --name multicloud-vio $NEXUS_DOCKER_REPO/onap/multicloud/vio:$DOCKER_IMAGE_VERSION