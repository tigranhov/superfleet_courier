# Define container name
$ContainerName = "superfleet-app"

# Check if the Docker container exists
if (docker ps -aq -f name=$ContainerName) {
    # If it does, delete the container
    Write-Output "Deleting existing Docker container: $ContainerName"
    docker rm -f $ContainerName
}

# Build the Docker image
Write-Output "Building Docker image..."
docker build -t $ContainerName:latest .

# Run the Docker container
Write-Output "Running Docker container on port 10004..."
docker run -d -p 10004:80 --name $ContainerName $ContainerName:latest
