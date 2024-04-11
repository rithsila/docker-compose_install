#!/bin/bash

# Update package lists and upgrade existing packages
sudo apt update
sudo apt upgrade -y
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    unzip \
    lsb-release \
    git

# Install Docker
sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Start Docker service
sudo systemctl enable --now docker

# Check Docker and Docker Compose versions
sudo docker version
sudo docker-compose version

# Clone SuiteCRM repository and download SuiteCRM
git clone https://github.com/jontitmus-code/SuiteCRM8_docker.git /root/SuiteCRM/
wget https://suitecrm.com/download/147/suite86/563895/suitecrm-8-6-0.zip -P /root/SuiteCRM/www/
unzip /root/SuiteCRM/www/suitecrm-8-6-0.zip -d /root/SuiteCRM/www/
