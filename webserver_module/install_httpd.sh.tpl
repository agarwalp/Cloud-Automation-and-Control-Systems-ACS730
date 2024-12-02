#!/bin/bash
# Update the instance and install HTTPD
sudo yum -y update
sudo yum -y install httpd

# Get the instance's private IP
myip=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

# Create a basic HTML file
sudo bash -c "cat > /var/www/html/index.html" <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>HTTPD Test</title>
</head>
<body>
    <h1>HTTPD is working!</h1>
    <p>Private IP: $myip</p>
</body>
</html>
EOF

# Start and enable the HTTPD service
sudo systemctl start httpd
sudo systemctl enable httpd

echo "HTTPD is set up and running. Visit the instance's public IP in your browser."
