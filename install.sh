#!/bin/bash

# Exit on error
set -e

echo "🔧 Updating system..."
sudo apt update && sudo apt upgrade -y  # For Debian-based systems
# sudo pacman -Syu   # Uncomment for Arch

echo "💾 Installing essential packages..."
sudo apt install -y vim git curl zsh  # Add your preferred packages
sudo apt install -y golang

echo "💾 Installing vsCode" 
sudo apt install curl gpg gnupg2 software-properties-common apt-transport-https 
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
sudo apt update && sudo apt install code -y

# Then add the following to your .bashrc
export GOROOT=/usr/lib/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
echo export $PATH=$PATH:$HOME/go/bin >> $home/.bashrc

# First, install the Scanner tools from PRoject Discovery
echo "💾 Installing Project Discovery's tools..."

echo "💾Installing Project discovery's management tool"
cd scanner/tools; \
git clone https://github.com/projectdiscovery/pdtm.git; \
cd pdtm/cmd/pdtm; \
go build; \
sudo mv pdtm /usr/local/bin/; \
pdtm -version \
cd

#Install all tools using the pdtm manager and dependencies
 sudo apt install -y libpcap-dev
pdtm -ia # installs all tools
pdtm


echo "🔧 update nuclei templates..."
nuclei -update-templates

#installing docker 
sudo apt install -y docker.io
sudo systemctl enable docker --now
sudo usermod -aG docker $USER
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian bookworm stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list 
curl -fsSL https://download.docker.com/linux/debian/gpg |
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io


echo "⚙️  Applying custom configurations..."
cp configs/.bashrc ~/.bashrc
cp configs/.vimrc ~/.vimrc

echo "🔄 Reloading shell..."
source ~/.bashrc
source ~/.zshrc

echo "✅ Customization complete!"