#!/usr/bin/env bash
set -euo pipefail


# Check required env variables
if [[ -z "${EC2_IP:-}" || -z "${S3_BUCKET:-}" ]]; then
  echo "Error: EC2_IP and S3_BUCKET environment variables must be set"
  exit 1
fi

# Path to your private key in the repo
KEY_PATH="pem/my-terraform-key.pem"

# Ensure SSH key exists
if [[ ! -f "$KEY_PATH" ]]; then
  echo "Error: SSH key not found at $KEY_PATH"
  exit 1
fi

# --- SSH Key Setup ---
echo "Setting up SSH key..."
mkdir -p ~/.ssh
cp "$KEY_PATH" ~/.ssh/id_rsa
chmod 400 ~/.ssh/id_rsa

# Disable strict host key checking (avoid CI host verification failure)
echo -e "Host *\n\tStrictHostKeyChecking no\n\n" > ~/.ssh/config
## Copy files
for f in yml/*.yml; do envsubst < "$f" > "$f.tmp" && mv "$f.tmp" "$f"; done
scp -i ~/.ssh/id_rsa yml/*.yml ubuntu@$EC2_IP:/home/ubuntu/deployments/
# --- Connect to EC2 ---
echo "Connecting to EC2 at $EC2_IP..."
ssh -i ~/.ssh/id_rsa ubuntu@"$EC2_IP" << 'EOF'
    if ! sudo docker version &> /dev/null
    then
        echo "Docker not found. Installing..."
        # Update apt and install prerequisite packages
        sudo apt-get update -y
        sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

        

        # Add Docker's official GPG key
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

        # Add Docker apt repository
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

        

        # Update apt again to include Docker repo packages

        sudo apt-get update -y

        

        # Install Docker Engine, CLI, containerd, and Docker Compose plugin

        sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin



    else

        echo "Docker is already installed."

    fi   

    # Check Docker Compose 

    if ! sudo docker compose version &> /dev/null

    then

        echo "Docker Compose not found. Installing..."

        sudo apt-get install docker-compose-plugin -y

    else

        echo "Docker Compose is already installed."

    fi

    

    # Start and enable Docker

    

    echo "Starting Docker..."

    sudo systemctl enable docker

    sudo systemctl start docker

    sudo systemctl status docker --no-pager
    
    cd /home/ubuntu/deployments
    sudo mkdir -p ./loki-data
    sudo chown -R 10001:10001 ./loki-data
    sudo docker compose pull
    sudo docker compose up -d


EOF
