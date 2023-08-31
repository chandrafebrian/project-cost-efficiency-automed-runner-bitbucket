#!/bin/bash
sudo rm -f /etc/resolv.conf

sudo cat > /etc/resolv.conf <<EOF
nameserver 172.x.x.x.x
nameserver 172.x.x.x.x
EOF

export DEBIAN_FRONTEND=noninteractive 

sudo apt-get update -y 
sudo apt-get install ca-certificates curl -y

curl -fsSL https://get.docker.com -o install-docker.sh
sudo sh install-docker.sh --version 24.0

sleep 45

sudo groupadd docker
sudo usermod -aG docker ubuntu
newgrp docker

sudo apt-get install awscli -y
mkdir -p /root/.docker
sudo apt-get install amazon-ecr-credential-helper -y

cat > ~/.docker/config.json <<EOF
{
  "credHelpers": {
    "your-id-ecr": "ecr-login"
  },
  "auths": {
    "https://index.docker.io/v1/": {}
  }
}
EOF

sleep 10

cat > /opt/install_runner.sh <<EOF
    $(aws ssm get-parameters --names ${parameter_name} --region=ap-southeast-1 --query "Parameters[0].Value" | tr -d \")
EOF

sleep 5
sed -i 's/run -it/run -d -it/g' /opt/install_runner.sh
sed -i 's/"//g' /opt/install_runner.sh
sleep 1

chmod +x /opt/install_runner.sh
sudo sh /opt/install_runner.sh

#Install Node Exporter
wget -c https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz
tar -xvf node_exporter-1.5.0.linux-amd64.tar.gz
chmod +x node_exporter-1.5.0.linux-amd64/node_exporter
mv node_exporter-1.5.0.linux-amd64/node_exporter /usr/local/bin/node_exporter

sudo /bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
sudo /sbin/mkswap /var/swap.1
sudo chmod 600 /var/swap.1
sudo /sbin/swapon /var/swap.1
echo '/var/swap.1   swap    swap    defaults        0   0' | sudo tee -a /etc/fstab
