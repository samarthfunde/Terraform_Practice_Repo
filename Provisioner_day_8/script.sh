#!/bin/bash

# Update package list
sudo apt update -y

# Install nginx 
sudo apt install nginx -y

# Start nginx service
sudo systemctl start nginx

# Enable nginx on boot
sudo systemctl enable nginx
