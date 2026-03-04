#!/bin/bash

# Update the package list
sudo apt update -y

# Install Nginx
sudo apt install nginx -y

# Start the Nginx service
sudo systemctl start nginx

# Enable Nginx to start on boot
sudo systemctl enable nginx

# Create a custom "Hello World" landing page
echo "<h1>Hello World from Nginx on EC2!</h1>" | sudo tee /var/www/html/index.nginx-debian.html

# Restart Nginx to apply changes
sudo systemctl restart nginx
