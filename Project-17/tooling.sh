#!/bin/bash
mkdir /var/www/
sudo mount -t efs -o tls,accesspoint=fsap-01c13a4019ca59dbe fs-8b501d3f:/ /var/www/
yum install -y httpd 
systemctl start httpd
systemctl enable httpd
yum module reset php -y
yum module enable php:remi-7.4 -y
yum install -y php php-common php-mbstring php-opcache php-intl php-xml php-gd php-curl php-mysqlnd php-fpm php-json
systemctl start php-fpm
systemctl enable php-fpm
git clone https://github.com/Livingstone95/tooling-1.git
#mkdir /var/www/html
sudo cp -rf tooling-1/html/*  /var/www/html/
cd tooling-1
mysql -h savvytek-database.c4scns6d3saq.eu-west-2.rds.amazonaws.com -u savvytekadmin -p toolingdb < tooling-db.sql
sudo touch healthstatus
sudo sed -i "s/$db = mysqli_connect('mysql.tooling.svc.cluster.local', 'admin', 'admin', 'tooling');/$db = mysqli_connect('savvytek-database.c4scns6d3saq.eu-west-2.rds.amazonaws.com', 'savvytekadmin', 'admin12345', 'toolingdb');/g" functions.php
chcon -t httpd_sys_rw_content_t /var/www/html/ -R
sudo systemctl restart httpd
sudo systemctl status httpd











