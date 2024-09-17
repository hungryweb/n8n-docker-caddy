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


# n8n with PostgreSQL

Starts n8n with PostgreSQL as database.

## Start

To start n8n with PostgreSQL simply start docker-compose by executing the following
command in the current folder.

**IMPORTANT:** But before you do that change the default users and passwords in the [`.env`](.env) file!

```
docker-compose up -d
```

To stop it execute:

```
docker-compose stop
```

## Configuration

The default name of the database, user and password for PostgreSQL can be changed in the [`.env`](.env) file in the current directory.



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