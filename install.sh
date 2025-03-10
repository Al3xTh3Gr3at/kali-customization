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

echo "💾Installing Nuclei"
cd scanner/tools; \
git clone https://github.com/projectdiscovery/nuclei.git; \
cd nuclei/cmd/nuclei; \
go build; \
mv nuclei /usr/local/bin/; \
nuclei -version \
cd

echo "💾Installing httpx"
cd scanner/tools; \
git clone https://github.com/projectdiscovery/httpx.git; \
cd httpx/cmd/httpx; \
go build; \
sudo mv httpx /usr/local/bin/; \
httpx -version \
cd

echo "💾Installing SubFinder"
cd scanner/tools; \
git clone https://github.com/projectdiscovery/subfinder.git; \
cd subfinder/v2/cmd/subfinder; \
go build; \
sudo mv subfinder /usr/local/bin/; \
subfinder -version; \
cd


go install -v github.com/projectdiscovery/uncover/cmd/uncover@latest
go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest
go install -v github.com/projectdiscovery/naabu/cmd/naabu@latest
go install github.com/projectdiscovery/katana/cmd/katana@latest
git clone https://github.com/PortSwigger/nuclei-burp-integration.git
wget https://repo1.maven.org/maven2/org/python/jython-installer/2.7.4/jython-installer-2.7.4.jar
sudo mv nuclei-burp-integration /opt
sudo mv jython-installer-2.7.4.jar /opt


echo "🔧 update nuclei templates..."
nuclei -update-templates


'''
#Install Filebeat and start it for home network only to passlogs to siem..
echo "💾 Installing filebeat to push the PD tool outputs to the local SIEM..."
curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-8.11.3-amd64.deb
sudo dpkg -i filebeat-8.11.3-amd64.deb
sudo systemctl enable filebeat
sudo systemctl start filebeat

# add your opensearch / kibana server to /etc/filebeat/filebeat.yml
filebeat.inputs:
  - type: log
    paths:
      - /path/to/nuclei_results.json
    json.keys_under_root: true
    json.add_error_key: true

output.elasticsearch:
  hosts: ["http://your-opensearch-ip:9200"]
  index: "nuclei-findings"
'''

echo "⚙️  Applying custom configurations..."
cp configs/.bashrc ~/.bashrc
cp configs/.vimrc ~/.vimrc

echo "🔄 Reloading shell..."
source ~/.bashrc

echo "✅ Customization complete!"