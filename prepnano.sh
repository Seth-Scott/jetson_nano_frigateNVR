#! /bin/bash
# INSTALLS DOCKER COMPOSE AND PREREQUISITES FOR RUNNING FRIGATE ON A 4GB JETSON NANO

echo "installing necessary programs"


echo "installing curl"
apt install -y curl

echo "installing nano"
apt install -y nano

echo "creating directory for docker compose"
DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
mkdir -p $DOCKER_CONFIG/cli-plugins



# NOTE: YOU WILL NEED TO REPLACE WITH THE RELEVANT FILE
# SEE FOR RELEASES: https://github.com/docker/compose/releases

echo "downloading docker compose"
if curl -SL https://github.com/docker/compose/releases/download/v2.16.0/docker-compose-linux-aarch64 -o $DOCKER_CONFIG/cli-plugins/docker-compose; then
  echo "download successful"
else
  echo "download failed, check version at https://github.com/docker/compose/releases"
  exit 1 # Exit the script with an error code
fi

echo "applying permissions.."
chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose

if echo $(docker compose version); then 
  echo "Docker Compose appears to be working correctly."
else
  echo "docker compose failed"
  exit 1 # Exit the script with an error code
fi
