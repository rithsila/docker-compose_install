#!/bin/bash

# Check if the script is running as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 
    exit 1
fi

# Update package lists and upgrade existing packages
apt update && apt upgrade -y

# Install prerequisites
apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    unzip \
    lsb-release

# Check if Docker is already installed
if ! command -v docker &> /dev/null; then
    # Set up Docker repository
    mkdir -m 0755 -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt update
    apt-get install -y docker-ce docker-ce-cli containerd.io
fi

# Check if Docker Compose is already installed
if ! command -v docker-compose &> /dev/null; then
    # Install Docker Compose
    apt-get install -y docker-compose
fi

# Test Docker installation
docker run hello-world

# Enable and start Docker service
systemctl enable --now docker

# Check Docker and Docker Compose versions
docker_version=$(docker --version)
docker_compose_version=$(docker-compose --version)

echo "Docker version: $docker_version"
echo "Docker Compose version: $docker_compose_version"
