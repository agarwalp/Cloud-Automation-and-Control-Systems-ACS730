#!/bin/bash
# Update packages and install Apache HTTP Server
sudo yum update -y
sudo yum install -y httpd

# Start and enable Apache
sudo systemctl start httpd
sudo systemctl enable httpd

# Create the HTML file
sudo bash -c 'cat > /var/www/html/index.html <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>ACS-Final-Assignment-Group1</title>
</head>
<body>
    <h1 style="text-align: center; color: blue;">ACS-Final-Project-Group1</h1>
    <p style="text-align: center;">Created by Pooja, Poonam, Shailendra, and Arjoo</p>
</body>
</html>
EOF'

# Ensure proper permissions
sudo chmod -R 755 /var/www/html

# Restart Apache to apply changes
sudo systemctl restart httpd
