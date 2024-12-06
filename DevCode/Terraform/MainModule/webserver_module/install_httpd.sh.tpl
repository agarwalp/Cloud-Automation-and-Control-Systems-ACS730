#!/bin/bash
# Update packages and install Apache HTTP Server
sudo yum update -y
sudo yum install -y httpd

# Start and enable Apache
sudo systemctl start httpd
sudo systemctl enable httpd

# Use the S3 URL of your image
IMAGE_URL="https://group1-acs730finalproject-dev.s3.us-east-1.amazonaws.com/picture.jpg"

# Fetch the EC2 instance Name tag
SERVER_NAME="${server_name}"

# Create the HTML file
sudo bash -c "cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>ACS730-FinalProject-Group1</title>
</head>
<body>
    <h1 style=\"text-align: center; color: blue;\">AC730-FinalProject-Group1</h1>
    <div style=\"text-align: center;\">
        <img src=\"$IMAGE_URL\" alt=\"Group Image\" width=\"300\">
    </div>
    <p style=\"text-align: center;\">Created by Pooja, Poonam, Shailendra, and Arjoo</p>
    <p style=\"text-align: center;\">Server Name: $SERVER_NAME</p>
</body>
</html>
EOF"

# Ensure proper permissions
sudo chmod -R 755 /var/www/html

# Restart Apache to apply changes
sudo systemctl restart httpd
