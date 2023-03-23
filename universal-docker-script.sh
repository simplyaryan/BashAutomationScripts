#!/bin/bash

# Prompt the user whether they want to install Docker
echo "do you want to install docker (y/n)"
read result

# Function to install Docker and Docker Compose
docker_install () {
	echo "updating repo's"
	sleep 2

	# Update the repository
	sudo chmod a+r /etc/apt/keyrings/docker.gpg
	sudo apt update
	echo "done"

	# Install required dependencies
	echo "installing required dependency"
	sleep 2
	sudo apt install ca-certificates curl gnupg lsb-release -y
	echo "done"

	# Get official GPG key
	echo "getting official gpg key"
	sleep 2
	sudo mkdir -m 0755 -p /etc/apt/keyrings
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
	echo "done"

	# Set up repository
	echo "setting up repo's"
	sleep 2
	echo \
	"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  	$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	echo "finally installing Docker and Docker-compose"
	sudo chmod a+r /etc/apt/keyrings/docker.gpg
	sudo apt-get update
	sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
	echo "done.."
	
	# Test the installation
	echo "testing"
	sudo docker run hello-world
	echo "Docker is now installed thanks for using this script -- ARYAN SINGH"
}

# Function to install and run Portainer
portainer_install () {
	sudo docker volume create portainer_data
	sudo docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
}

nginx_proxy_manager () {
	wget https://raw.githubusercontent.com/Aryan-javamaster/BashScrpits/main/nginx-docker-compose.yml
	mv nginx-docker-compose.yml docker-compose.yml
	docker compose up -d
}

# If the user wants to install Docker
if [[ $result == "y" ]]; then
	echo "Downloading......docker"
	docker_install
	
	# Prompt the user whether they want to install Portainer
	echo "do you want to install portainer: Portainer is a GUI to manage all your containers (y/n)"
	read portainer
	
	# If the user wants to install Portainer
	if [[ $portainer == "y" ]]; then 
		portainer_install
		ip=$(hostname -I)
		echo "Portainer is now installed and running. You can access the GUI at https://$ip:9443"
		echo "do you want to install ngnix-proxy-manager(GUI version)(y/n)"
		read nginx
		if [[ $nginx == "y" ]]; then
			nginx_proxy_manager
		fi
	else 
		exit		
	fi
else 
	exit
fi 
