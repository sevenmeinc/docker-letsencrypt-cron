#!/bin/bash

# Parse arguments
# From: http://stackoverflow.com/a/14203146

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -v|--version)
    VERSION=":$2"
    shift # past argument
    ;;
    *)
          # unknown option
    ;;
esac
shift # past argument or value
done

IMAGE_NAME="certbot"
REGISTRY_NAME="docker.seven.me/seven/$IMAGE_NAME$VERSION"

# Build docker image
docker build --pull -t $IMAGE_NAME .

# Push to docker registry
cat ~/.docker-pass | docker login -u admin --password-stdin docker.seven.me
docker tag $IMAGE_NAME "$REGISTRY_NAME"
docker push "$REGISTRY_NAME"

# Clean up
docker rmi $IMAGE_NAME
docker rmi "$REGISTRY_NAME"

