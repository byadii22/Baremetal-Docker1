#!/bin/bash

function addDockerKey
{
    echo "### Adding Docker key.asc to keyring..."
    apt-get -qq -y update 
    apt-get -qq -y install ca-certificates curl 
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    chmod a+r /etc/apt/keyrings/docker.asc
}

function addDockerRepository
{
    echo "### Adding Docker repository..." 
    echo \
     "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
     $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
     tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt-get -qq -y  update
}

function installDocker
{
    echo "### Install Docker..."
    apt-get -qq -y  install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

function AddUserToDockerGroup()
{
    local new_user_name=$1
    echo "### User $new_user_name attaching to docker group..."
    usermod -aG docker $new_user_name
}

echo "### Running..."
#########################################
#### DOCKER INSTALLATION PART
#########################################
addDockerKey
addDockerRepository
installDocker

echo "### Done!"
