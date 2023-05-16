#!/bin/bash

# Define container and image name
NAME=superfleet-app

# Pull the latest code
echo "Pulling latest code..."
git pull

# Check if the Docker container exists
if [ "$(docker ps -aq -f name=${NAME})" ]; then
    # If it does, delete the container
    echo "Deleting existing Docker container: ${NAME}"
    docker rm -f ${NAME}
fi

# Check if the Docker image exists
if [ "$(docker images -q ${NAME}:latest)" ]; then
    # If it does, delete the image
    echo "Deleting existing Docker image: ${NAME}"
    docker rmi -f ${NAME}:latest
fi

# Build the Docker image
echo "Building Docker image..."
docker build -t ${NAME}:latest .

# Run the Docker container
echo "Running Docker container on port 10004..."
docker run -d --restart=unless-stopped -p 10004:80 --name ${NAME} ${NAME}:latest
