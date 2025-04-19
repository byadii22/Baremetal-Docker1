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
    apt-get -qq -y update
}

function installDocker
{
    echo "### Install Docker..."
    apt-get -qq -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

function AddUserToDockerGroup() {
    local user_name=$1
    echo "### User $user_name attaching to docker group..."
    usermod -aG docker $user_name
}

# Parsowanie argumentów
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -u|--user) 
            user_name="$2"
            shift # Przesunięcie argumentu o 1
            ;;
        *) 
            echo "Nieznana opcja: $1"
            exit 1
            ;;
    esac
    shift
done

# Sprawdzenie, czy podano nazwę użytkownika
if [[ -z "$user_name" ]]; then
    echo "Użycie: $0 -u|--user <nazwauzytkownika>"
    exit 1
fi

echo "### Running..."
#########################################
#### DOCKER INSTALLATION PART
#########################################
addDockerKey
addDockerRepository
installDocker

#########################################
#### ADDING USER TO DOCKER GROUP PART
#########################################
AddUserToDockerGroup "$user_name"

echo "### Done!"
