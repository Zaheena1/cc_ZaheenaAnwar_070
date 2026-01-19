#!/bin/bash
sudo yum update -y
sudo yum install -y nginx mod_ssl

# Create a custom index page with your name
echo "<h1>Hello, this is Urooj's Terraform Environment</h1>" | sudo tee /usr/share/nginx/html/index.html

# Generate Self-Signed Certificate
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/pki/tls/private/localhost.key \
  -out /etc/pki/tls/certs/localhost.crt \
  -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"

# Configure Nginx for HTTPS
sudo cat <<EOC > /etc/nginx/conf.d/ssl.conf
server {
    listen 443 ssl;
    server_name localhost;

    ssl_certificate /etc/pki/tls/certs/localhost.crt;
    ssl_certificate_key /etc/pki/tls/private/localhost.key;

    location / {
        root /usr/share/nginx/html;
        index index.html index.htm;
    }
}
server {
    listen 80;
    server_name localhost;
    return 301 https://\$host\$request_uri;
}
EOC

# Start Nginx
sudo systemctl enable nginx
sudo systemctl start nginx
