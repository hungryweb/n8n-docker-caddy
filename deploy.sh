#!/bin/bash

# Change to the n8n-docker-caddy directory
cd n8n-docker-caddy/

# Pull the latest Docker images
sudo docker compose pull

# Stop and remove the current containers
sudo docker compose down

# Start the containers in detached mode
sudo docker compose up -d

echo "Deployment completed successfully."

sudo docker image prune -f -a --filter "until=1h"

echo "Images cleanup completed successfully."

sudo docker container prune -f

echo "Containers cleanup completed successfully."