#!/bin/bash

# Update system packages
sudo apt update

# Install Python 3, pip, and other essentials
sudo apt install python3 python3-pip python3-venv git -y

# Define the current user and set the project directory
CURRENT_USER=$(whoami)
PROJECT_DIR="/home/$CURRENT_USER/myprojectdir"

# Clone your Django project from a repository into 'myprojectdir'
git clone https://github.com/pietow/blog_api_live.git myprojectdir

# Change to your project directory
cd $PROJECT_DIR

# Create a Python virtual environment and activate it
python3 -m venv .venv
source .venv/bin/activate

# Install Gunicorn and other dependencies
pip install -r requirements.txt
pip install gunicorn

# Run Django migrations and collect static files
python manage.py migrate
python manage.py collectstatic --noinput

# Install Nginx
sudo apt install nginx -y
# Create Gunicorn socket file
cat << EOF | sudo tee /etc/systemd/system/gunicorn.socket
[Unit]
Description=gunicorn socket

[Socket]
ListenStream=/run/gunicorn.sock

[Install]
WantedBy=sockets.target
EOF

# Create Gunicorn service file
cat << EOF | sudo tee /etc/systemd/system/gunicorn.service
[Unit]
Description=gunicorn daemon
Requires=gunicorn.socket
After=network.target

[Service]
User=$CURRENT_USER
Group=www-data
WorkingDirectory=$PROJECT_DIR
ExecStart=$PROJECT_DIR/.venv/bin/gunicorn \
          --access-logfile - \
          --workers 3 \
          --bind unix:/run/gunicorn.sock \
          django_project.wsgi:application

[Install]
WantedBy=multi-user.target
EOF

# Start and enable Gunicorn socket and service
sudo systemctl start gunicorn.socket
sudo systemctl enable gunicorn.socket
sudo systemctl start gunicorn
sudo systemctl enable gunicorn

# Fetch the public IP address
PUBLIC_IP=$(curl -s http://ifconfig.me)

# Setup Nginx to Proxy Pass to Gunicorn
cat << EOF | sudo tee /etc/nginx/sites-available/myproject
server {
    listen 80;
    server_name $PUBLIC_IP;  # Set your server's public IP here

    location = /favicon.ico { access_log off; log_not_found off; }
    location /static/ {
        root $PROJECT_DIR;
    }

    location / {
        include proxy_params;
        proxy_pass http://unix:/run/gunicorn.sock;
    }
}
EOF

# Enable the Nginx site configuration
sudo ln -s /etc/nginx/sites-available/myproject /etc/nginx/sites-enabled
sudo usermod -a -G ubuntu www-data
sudo chown -R :www-data ./static
sudo systemctl restart nginx
