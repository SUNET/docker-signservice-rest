#!/bin/bash

echo Deploying docker containter signservice-integration-rest
docker run -d --name signservice-integration-rest --restart=always \
  -p 8080:8080 -p 8009:8009 \
  -e "SPRING_CONFIG_ADDITIONAL_LOCATION=/opt/signservice-integration-rest/" \
  -v /etc/localtime:/etc/localtime:ro \
  -v /opt/docker/signservice-integration-rest:/opt/signservice-integration-rest \
  signservice-integration-rest

echo Done!
