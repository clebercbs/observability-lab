sudo apt update
sudo apt install docker.io docker-compose-plugin -y
sudo systemctl enable docker
sudo systemctl start docker

cd /opt
sudo git clone https://github.com/clebercbs/observability-lab.git
sudo chown -R $USER:$USER observability-lab
cd observability-lab

docker compose up -d

