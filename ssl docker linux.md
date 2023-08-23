# Automated Setup Script for Web Server and Docker Container

This is a bash script that automates the setup of a web server using Nginx and optionally deploys a Docker container. It also configures SSL using Certbot for secure connections.

## Update the System and Install Nginx

```bash
#!/bin/bash

# Update the system
apt update

# Install Nginx
apt install nginx

# Check Nginx status
systemctl status nginx
```

## Configure Firewall (UFW) and Allow Necessary Ports

```bash
# Check UFW application list and status
ufw app list
sudo ufw status

# Allow ports for Nginx and SSH
ufw allow 'Nginx Full'
ufw allow 'OpenSSH'
ufw allow 'Nginx HTTP'

# Enable and display UFW rules
ufw enable
ufw list
ufw status
```

## Install SSL Certificate using Certbot

```bash
# Install Certbot and SSL support for Nginx
apt install certbot python3-certbot-nginx

# Obtain and configure SSL certificate using Certbot
certbot --nginx -d socket.example.com
```

## (Optional) Install Docker for Container Deployment

```bash
# Install Docker dependencies
apt-get install ca-certificates curl gnupg lsb-release

# Configure Docker repository
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update packages and install Docker
apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
```

## Configure Docker Container (Sample Script)

```bash
# Create a script to update and run the Docker container
echo '#!/bin/bash
# Stop and remove existing Docker containers
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)

# Remove existing Docker images
docker rmi $(docker images -a -q)

# Pull the latest version of the Docker image from the repository
docker pull user/websocket:master

# Run a new Docker container with port mapping
docker run -t -d -p 8080:8080 --name my-docker-container user/websocket:master

# Inform the developer that the Docker container has been updated and is running
echo "Docker container has been updated and is now running."' > update.sh

# Make the update.sh file executable
chmod +x update.sh

# Execute the script
./update.sh
```

## Update Nginx Configuration for Reverse Proxy

```bash
# Edit Nginx default configuration
nano /etc/nginx/sites-available/default

# Find the server block for your domain and update the location block
server_name socket.example.com; # managed by Certbot

location / {
    proxy_pass http://localhost:8080;
}
```

## Restart Nginx

```bash
# Restart Nginx service
systemctl restart nginx.service
```
