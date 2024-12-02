#!/bin/bash
sudo yum -y update
sudo yum -y install httpd
private_ip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
sudo aws s3 cp s3://${env}-finalproject-acs730-group10/images/seneca.jpg /var/www/html


echo "<html>
  <head>
<title>Group 10</title>
 </head>
 <body>
<center>
    <h1>private_IP is $private_ip</h1>
    <h1>Running on ${env} </h1>
</center>

<table border="5" bordercolor="grey" align="center">
    <tr>
        <th>Loaded From S3</th>
    </tr>
    <tr>
        <td><img src="seneca.jpg" alt="seneca" border=3 height=200 width=300></img></th>
    </tr>
</table>
  </body>
  <html>" > /var/www/html/index.html
sudo systemctl start httpd
sudo systemctl enable httpd