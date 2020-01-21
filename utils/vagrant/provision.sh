#!/bin/bash 

# Adjust to closest mirrors.
sudo sed -i -e 's/http:\/\/us.archive/mirror:\/\/mirrors/' -e 's/\/ubuntu\//\/mirrors.txt/' /etc/apt/sources.list

# Standard stuff for fresh system.
sudo apt-get update -y
sudo apt-get upgrade -y -qq # The quiet flag suppresses annoying GRUB interactive.

# Install to allow apt to use a repository over HTTPS
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common -y

# Install pip for Python 3.
sudo apt-get install python3-pip -y

# Install Node.js.
sudo apt-get install nodejs -y

# Add Dockerr's official GPG key and set up stable repository
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# Install latest version of Docker
sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

# Add user vagrant to group docker
sudo usermod -aG docker vagrant

# Clone, build and install Smartbugs
cd ~
if [ ! -d smartbugs ]; then 
    git clone https://github.com/smartbugs/smartbugs.git smartbugs
    cd smartbugs
    pip3 install -r requirements.txt
else
    cd smartbugs
    git pull
    pip3 install -r requirements.txt
fi

# Use antlr4-python3-runtime v4.7.2 to avoid warnings
pip3 install -Iv antlr4-python3-runtime==4.7.2

# Change MOTD

sudo sh -c 'echo "\
 ____                       _   ____                  
/ ___| _ __ ___   __ _ _ __| |_| __ ) _   _  __ _ ___ 
\___ \| '"'"'_ \` _ \ / _\` | '"'"'__| __|  _ \| | | |/ _\` / __|
 ___) | | | | | | (_| | |  | |_| |_) | |_| | (_| \__ \ 
|____/|_| |_| |_|\__,_|_|   \__|____/ \__,_|\__, |___/
                                            |___/     

Welcome! SmartBugs usage example:

	cd smartbugs
	./smartBugs.py --dataset reentrancy -t oyente

For more details and documentation: https://smartbugs.github.io

" > /etc/motd'
