#!/bin/bash -x

rm -f ~/.npmrc

sudo apt install -y docker.io docker-compose

sudo addgroup --system docker
sudo adduser $USERNAME docker

python3 -m pip install invenio-cli

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

if [[ -s $HOME/.nvm/nvm.sh ]]; then
    . $HOME/.nvm/nvm.sh

    nvm install 14.0.0
else
    echo -e "\033[33;31m———————————————————————————————————————————————————\033[0m"
    echo -e "\033[33;31mCould not make NVM work -- check it and try again.\033[0m"
    echo -e "\033[33;31m———————————————————————————————————————————————————\033[0m"
fi
