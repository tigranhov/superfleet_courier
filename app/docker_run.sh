#!/bin/bash

# Define container name
CONTAINER_NAME=superfleet-app

# Check if the Docker container exists
if [ "$(docker ps -aq -f name=${CONTAINER_NAME})" ]; then
    # If it does, delete the container
    echo "Deleting existing Docker container: ${CONTAINER_NAME}"
    docker rm -f ${CONTAINER_NAME}
fi

# Build the Docker image
echo "Building Docker image..."
docker build -t ${CONTAINER_NAME}:latest .

# Run the Docker container
echo "Running Docker container on port 10004..."
docker run -d -p 10004:80 --name ${CONTAINER_NAME} ${CONTAINER_NAME}:latest
