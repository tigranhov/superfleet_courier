# Define container and image name
$Name = "superfleet-app"

# Pull the latest code
Write-Output "Pulling latest code..."
git pull

# Check if the Docker container exists
if (docker ps -aq -f name=$Name) {
    # If it does, delete the container
    Write-Output "Deleting existing Docker container: $Name"
    docker rm -f $Name
}

# Check if the Docker image exists
if (docker images -q $Name':latest') {
    # If it does, delete the image
    Write-Output "Deleting existing Docker image: $Name"
    docker rmi -f $Name':latest'
}

# Build the Docker image
Write-Output "Building Docker image..."
docker build -t $Name':latest' .

# Run the Docker container
Write-Output "Running Docker container on port 10004..."
docker run -d --restart=unless-stopped -p 10004:80 --name $Name $Name':latest'
