#!/bin/bash

# Update system packages
sudo dnf update -y

# Install Docker
sudo dnf install -y docker
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ec2-user

# Install kubectl
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.31/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.31/rpm/repodata/repomd.xml.key
EOF
sudo yum install -y kubectl

# Install required dependencies
sudo dnf install -y conntrack git

# Install Helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

# Install Minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# Create necessary directories
sudo -u ec2-user mkdir -p /home/ec2-user/.kube
sudo -u ec2-user mkdir -p /home/ec2-user/helm-charts
sudo chown -R ec2-user:ec2-user /home/ec2-user/.kube
sudo chown -R ec2-user:ec2-user /home/ec2-user/helm-charts

# Download Helm charts from S3
aws s3 cp s3://k8s-deployment-manifests/helm-charts/ /home/ec2-user/helm-charts/ --recursive

# Start Minikube
sudo -u ec2-user CHANGE_MINIKUBE_NONE_USER=true minikube start \
  --driver=docker \
  --cpus=2 \
  --memory=2048 \
  --kubernetes-version=stable

# Wait for minikube to be ready
sleep 30

# Configure kubectl
sudo -u ec2-user minikube update-context

# Extract hostname from the endpoint
db_host=$(echo "${db_endpoint}" | cut -d':' -f1)

# Create values file for production deployment
cat <<EOFF > /home/ec2-user/helm-charts/values-production.yaml
image:
  repository: yaroslavkse/golang-demo
  tag: latest
  pullPolicy: Always

service:
  type: NodePort
  port: 8080
  targetPort: 8080

config:
  environment: prod
  database:
    local:
      enabled: false
    external:
      enabled: true
      host: "${db_host}"
      port: ${db_port}
      credentials:
        username: "${db_username}"
        password: "${db_password}"
        database: "${db_name}"

dbInit:
  enabled: true
EOFF

# Deploy with Helm
cd /home/ec2-user/helm-charts
sudo -u ec2-user helm upgrade --install golang-demo . -f values-production.yaml

# Install PostgresSQL client
sudo dnf install postgresql16.x86_64 -y

# Create the videos table in the database
sudo -u ec2-user PGPASSWORD="${db_password}" psql -h ${db_host} -U ${db_username} -d ${db_name} << EOF
CREATE TABLE IF NOT EXISTS videos (
  id VARCHAR(255) NOT NULL,
  title VARCHAR(255) NOT NULL
);
EOF

# Install and configure Nginx
sudo dnf install -y nginx

# Get minikube IP and NodePort
MINIKUBE_IP=$(sudo -u ec2-user minikube ip)
NODE_PORT=$(sudo -u ec2-user kubectl get svc golang-demo-golang-demo -o jsonpath='{.spec.ports[0].nodePort}')

# Create Nginx configuration
cat << EOFF | sudo tee /etc/nginx/conf.d/kubernetes.conf
server {
    listen 80;
    server_name ${domain_name};
    location / {
        proxy_pass http://${MINIKUBE_IP}:${NODE_PORT};
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOFF

# Start Nginx
sudo systemctl enable nginx
sudo systemctl restart nginx
