#!/bin/bash

INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

echo "WebServer${INSTANCE_ID}" > /etc/hostname
hostnamectl set-hostname "WebServer${INSTANCE_ID}"

echo "<!DOCTYPE html>
<html>
<head>
    <title>HTTPD Test</title>
</head>
<body>
    <h1>HTTPD is working!</h1>
    <p>Instance ID: ${INSTANCE_ID}</p>
</body>
</html>" > /var/www/html/index.html

# Install and start HTTPD
yum install -y httpd
systemctl enable httpd
systemctl start httpd