# n8n-docker-caddy

Get up and running with n8n on the following platforms:

* [DigitalOcean tutorial](https://docs.n8n.io/hosting/server-setups/digital-ocean/)
* [Hetzner Cloud tutorial](https://docs.n8n.io/hosting/server-setups/hetzner/)

If you have questions after trying the tutorials, check out the [forums](https://community.n8n.io/).

## Prerequisites

Self-hosting n8n requires technical knowledge, including:

* Setting up and configuring servers and containers
* Managing application resources and scaling
* Securing servers and applications
* Configuring n8n

n8n recommends self-hosting for expert users. Mistakes can lead to data loss, security issues, and downtime. If you aren't experienced at managing servers, n8n recommends [n8n Cloud](https://n8n.io/cloud/).

# Ubuntu installation

```bash
sudo apt update && sudo apt -y upgrade

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```


# n8n with PostgreSQL

Starts n8n with PostgreSQL as database.


## Configuration

The default name of the database, user and password for PostgreSQL can be changed in the [`.env`](.env) file in the current directory.

```
sudo git clone https://github.com/hungryweb/n8n-docker-caddy.git
cd n8n-docker-caddy
sudo cp .env.example .env
sudo nano .env
sudo nano caddy_config/Caddyfile
```

## Create Docker volumes

To persist the Caddy cache between restarts and speed up start times, create a Docker volume that Docker reuses between restarts:

```
sudo docker volume create caddy_storage
```

Create a Docker volume for the n8n data:

```
sudo docker volume create n8n_storage
```

Create a Docker volume for the postgres data:

```
sudo docker volume create db_storage
```

## Set up DNS

n8n typically operates on a subdomain. Create a DNS record with your provider for the subdomain and point it to the IP address of the Droplet. The exact steps for this depend on your DNS provider, but typically you need to create a new "A" record for the n8n subdomain.

## Configure Caddy

Caddy needs to know which domains it should serve, and which port to expose to the outside world. Edit the Caddyfile file in the caddy_config folder.

```
sudo nano caddy_config/Caddyfile
```

Change the placeholder domain to yours. If you followed the steps to name the subdomain n8n, your full domain is similar to n8n.example.com. The n8n in the reverse_proxy setting tells Caddy to use the service definition defined in the docker-compose.yml file:

```
n8n.<domain>.<suffix> {
    reverse_proxy n8n:5678 {
      flush_interval -1
    }
}
```

If you were to use automate.example.com, your Caddyfile may look something like:

```
automate.example.com {
    reverse_proxy n8n:5678 {
      flush_interval -1
    }
}
```


## Start Docker Compose

Start n8n and Caddy with the following command:
```
sudo docker compose up -d
```

This may take a few minutes.

### Test your setup

In your browser, open the URL formed of the subdomain and domain name defined earlier. Enter the user name and password defined earlier, and you should be able to access n8n.

### Stop n8n and Caddy

You can stop n8n and Caddy with the following command:

```
sudo docker compose stop
```

### Update self-hosted n8n

If you run n8n using a Docker Compose file, follow these steps to update n8n:

```
# Pull latest version
sudo docker compose pull

# Stop and remove older version
sudo docker compose down

# Start the container
sudo docker compose up -d
```

# Deploy script

1. Save the content in a file named *deploy.sh*

```
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
```

2. Make the script executable by running:
```
chmod +x deploy.sh
```

3. Execute the script with: ./deploy.sh
