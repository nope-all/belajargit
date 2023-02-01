#!/bin/bash

clear
echo "What should i do?"
echo
echo "Select an options:"
echo "   1) Update Ubuntu"
echo "   2) Upgrade Ubuntu"
echo "   3) Install Docker"
echo "   4) Install Portainer"
read -p "Option: " option
until [[ "$option" =~ ^[1-4]$ ]]; do
		echo "$option: invalid selection."
		read -p "Option: " option
done
case "$option" in
    1)
      echo
      read -p "Are you sure to update ubuntu? [y/n]: " update
      until [[ "$update" =~ ^[yYnN]*$ ]]; do
          echo "$update: invalid selection."
          read -p "Are you sure to update ubuntu? [y/n]: " update
      done
      if [[ "$update" =~ ^[yY]$ ]]; then
          sudo apt-get update -y;
          echo
          echo "Ubuntu has been updated"
      else
          echo
          echo "Update aborted!"
      fi
      exit
    ;;
    2)
      read -p "Are you sure to upgrade ubuntu? [y/n]: " upgrade
      until [[ "$upgrade" =~ ^[yYnN]*$ ]]; do
          echo "$upgrade: invalid selection."
          read -p "Are you sure to upgrade ubuntu? [y/n]: " upgrade
      done
      if [[ "$upgrade" =~ ^[yY]$ ]]; then
          sudo apt-get upgrade -y;
          echo
          echo "Ubuntu has been upgraded"
      else
          echo
          echo "Upgrade aborted!"
      fi
      exit
    ;;
    3)
      read -p "Are you sure to Install Docker? [y/n]: " docker
      until [[ "$docker" =~ ^[yYnN]*$ ]]; do
          echo "$docker: invalid selection."
          read -p "Are you sure to Install Docker? [y/n]: " docker
      done
      if [[ "$docker" =~ ^[yY]$ ]]; then
          sudo apt-get update -y;
          sudo apt-get upgrade -y;

          sudo apt-get install \
          ca-certificates \
          curl \
          gnupg \
          lsb-release -y;

          sudo mkdir -p /etc/apt/keyrings;
          curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg;

          echo \
          "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
          $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null;

          sudo apt-get update -y;
          sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y;
          sudo service docker start;
          echo
          echo "Docker has been installed"
      else
          echo
          echo "Install Docker aborted!"
      fi
      exit
    ;;
    4)
      read -p "Are you sure to install portainer? [y/n]: " portainer
      until [[ "$portainer" =~ ^[yYnN]*$ ]]; do
          echo "$portainer: invalid selection."
          read -p "Are you sure to install portainer? [y/n]: " portainer
      done
      if [[ "$portainer" =~ ^[yY]$ ]]; then
          sudo service docker restart;
          sudo docker pull portainer/portainer-ce;
          sudo docker volume create portainer_data;
          sudo docker run -d \
               -p 8000:8000 \
               -p 9443:9443 \
               --name portainer \
               --restart=always \
               -v /var/run/docker.sock:/var/run/docker.sock \
               -v portainer_data:/data \
          portainer/portainer-ce:latest;
          echo
          echo "Portainer has been installed"
      else
          echo
          echo "Install Portainer aborted!"
      fi
      exit
      ;;
	esac
