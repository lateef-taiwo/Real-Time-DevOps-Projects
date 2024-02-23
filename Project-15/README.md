### AWS-CLOUD-SOLUTION-FOR-2-COMPANY-WEBSITES-USING-A-REVERSE-PROXY-TECHNOLOGY
------
#### General Overview
You will build a secure infrastructure inside AWS VPC (Virtual Private Cloud) for a fictitious company named WakaBetter that uses WordPress CMS for its main business website, and a Tooling Website for their DevOps team. As part of the company’s desire for improved security and performance, a decision has been made to use a reverse proxy technology from NGINX to achieve this. Cost, Security, and Scalability are the major requirements for this project. Hence, implementing the architecture designed below, ensure that infrastructure for both websites, WordPress and Tooling, is resilient to Web Server’s failures, can accomodate to increased traffic and, at the same time, has reasonable cost. 

![](./images/Architecture-Diagram.png)

### Requirements
There are few requirements that must be met before you begin:

1. Properly configure your AWS account and Organization Unit Watch How To Do This Here
    * Create an AWS Master account. (Also known as Root Account)
    * Within the Root account, create a sub-account and name it DevOps. (You will need another email address to complete this) 

    ![](./images/aws-organizations.png)

    ![](./images/aws-organizations.png)

    ![](./images/create.png)

    ![](./images/devops.png)

    * Within the Root account, create an AWS Organization Unit (OU). Name it Dev. (We will launch Dev resources in there).

    ![](./images/ou.png)

    ![](./images/dev.png)

    * Move the DevOps account into the Dev OU. 
    ![](./images/move.png)

    ![](./images/move-2.png)

    ![](./images/dev-devops.png)

    * Login to the newly created AWS account using the new email address.

    ![](./images/devops2.png)

2. Create a domain name for your company. I used [namecheap](https://www.namecheap.com/).
3. Create a hosted zone in AWS, and map it to your domain. 

 ![](./images/route53.png)

 ![](./images/create-hosted-zone.png)

 ![](./images/savvytek.png)

 ![](./images/ns.png)

 ![](./images/ns-2.png)

 ### SET UP A VIRTUAL PRIVATE CLOUD (VPC)
 --------
1. Create a VPC

 ![](./images/create-vpc.png)

 ![](./images/vpc-config.png)

2. Enable DNS hosting

 ![](./images/enable.png)

 3. Create internet gateway as shown in the architecture.

 ![](./images/igw.png)

 ![](./images/create%20igw.png)

 ![](./images/savvytek-igw.png)

 ![](./images/attack-to-vpc.png)

 ![](./images/attach-vpc-2.png)

4. Create the subnets as shown in the Architecture

Use this website to get the CIDR blocks easily. [ipinfo](https://ipinfo.io/ips).

![](./images/create-subnet.png)

![](./images/create-subnet-vpc-id.png)

![](./images/create-subnet-2.png)

![](./images/create-subnet-3.png)

![](./images/create-subnet-4.png)

![](./images/create-subnet-5.png)

![](./images/create-subnet-6.png)

![](./images/subnets.png)

5. Create a route table and associate it with public subnets

![](./images/route-table-1.png)

![](./images/edit-subnet-associations-1.png)

![](./images/edit-subnet-associations-2.png)

![](./images/public-route-table.png)

6. Create a route table and associate it with private subnets

![](./images/route-table-2.png)

![](./images/edit-subnet-associations-3.png)

![](./images/edit-subnet-associations-4.png)

![](./images/route-tables.png)

7. Edit a route in public route table, and associate it with the Internet Gateway. (This is what allows a public subnet to be accessible from the Internet).

 ![](./images/edit-routes.png)

 ![](./images/edit-routes-2.png)

 8. Create 3 Elastic IPs
 ![](./images/elastic-ip-1.png)

 ![](./images/elastic-ips.png)

 9. Create a Nat Gateway and assign one of the Elastic IPs (*The other 2 will be used by Bastion hosts).
![](./images/ngw-1.png)

![](./images/ngw-2.png)

![](./images/ngw-3.png)

![](./images/edit-route-3.png)

![](./images/edit-route-4.png)

10. Create a Security Group for:
    * External Application Load Balancer: External ALB will be accessible from the Internet

    ![](./images/create-SG.png)

    ![](./images/SG-ALB.png)


    * Bastion Servers: Access to the Bastion servers should be allowed only from workstations that need to SSH into the bastion servers. Hence, you can use your workstation public IP address.

    ![](./images/bastion-sg.png)

    * Nginx Reverse Proxy Servers: Access to Nginx should only be allowed from a Application Load balancer (ALB).

    ![](./images/nginx-sg.png)

    ![](./images/nginx-sg-2.png)

    * Internal Application Load Balancer: ALB will be available from the Nginx servers

    ![](./images/internal-alb-sg.png)

    * Webservers: Access to Webservers should only be allowed from the Internal Application Load Balancer. 

    ![](./images/web-server-sg.png)

    * Data Layer: Access to the Data layer, which is comprised of Amazon Relational Database Service (RDS) and Amazon Elastic File System (EFS) must be carefully designed – only webservers should be able to connect to RDS, while Nginx and Webservers will have access to EFS Mountpoint.

    ![](./images/data-layer-sg.png)

### TLS Certificates From Amazon Certificate Manager (ACM)

You will need TLS certificates to handle secured connectivity to your Application Load Balancers (ALB).

* Navigate to AWS ACM

![](./images/acm.png)

![](./images/request-certificate.png)

![](./images/request-public-certificate.png)

![](./images/request-public-certificate-2.png)

![](./images/request-public-certificate-3.png)

![](./images/create-records-in-route53.png)

![](./images/create-records.png)

![](./images/issued.png)

Configure EFS
---
* Create a new EFS File system. Create an EFS mount target per AZ in the VPC, associate it with both subnets dedicated for data layer. Associate the Security groups created earlier for data layer.

![](./images/efs.png)

![](./images/create-file-system.png)

![](./images/create-efs-customize.png)

![](./images/mount-tagets.png)

![](./images/file-system-policy.png)

![](./images/create-for-file-system.png)

![](./images/savvytek-EFS.png)

* Create 2 access points - ! for each of the website (wordpress and tooling) so that the files do not overwrite each other when we mount. 

![](./images/create-access-point.png)

![](./images/efs-details-1.png)

![](./images/efs-details-2.png)

![](./images/create-access-point-2.png)

![](./images/create-access-point-3.png)

![](./images/details-tooling.png)

![](./images/details-tooling-2.png)

![](./images/create-access-point-4.png)

### Configure RDS
-----
#### Pre-requisite:

* Create a KMS Key
![](./images/kms.png)

![](./images/create-a-key.png)

![](./images/configure-key-next.png)

![](./images/alias-kms.png)

![](./images/search-key-administrators.png)

![](./images/search-key-users.png)

![](./images/finish.png)

To ensure that yout databases are highly available and also have failover support in case one availability zone fails, we will configure a multi-AZ set up of RDS MySQL database instance. In our case, since we are only using 2 AZs, we can only failover to one, but the same concept applies to 3 Availability Zones.

To configure RDS, follow steps below:

1. Create a subnet group and add 2 private subnets (data Layer)

2. Create the DataBase

![](./images/create-db-subnet-group.png)

![](./images/subnet-group-details-1.png)

![](./images/subnet-group-details-2.png)

Now create the DB
![](./images/create-database.png)

![](./images/choose-database.png)

![](./images/engine-version.png)

![](./images/db-instance-identifier.png)

![](./images/db-config.png)

![](./images/db-config-2.png)

![](./images/enable-encryption.png)

![](./images/create-database-2.png)

### Set Up Compute Resources for Bastion
-----
#### Provision the EC2 Instances for Bastion
Create an EC2 Instance based on Red Hat Enterprise Linux (AMI) (You can search for this ami, RHEL-8.7.0_HVM-20230215-x86_64-13-Hourly2-GP2
) per each Availability Zone in the same Region and same AZ where you created Nginx server
* Ensure that it has the following software installed
   * python
   * ntp
   * net-tools
   * vim
   * wget
   * telnet
   * epel-release
   * htop

We will use instance to create an ami for launching instances in Auto-scaling groups so all the installations will be done before creating the ami from the instance

### Bastion ami installation

    sudu su -
    yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm 
    yum install -y dnf-utils http://rpms.remirepo.net/enterprise/remi-release-8.rpm 
    yum install wget vim python3 telnet htop git mysql net-tools chrony -y 
    systemctl start chronyd 
    systemctl enable chronyd

#### Nginx ami installation

    yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm

    yum install -y dnf-utils http://rpms.remirepo.net/enterprise/remi-release-8.rpm

    yum install wget vim python3 telnet htop git mysql net-tools chrony -y

    systemctl start chronyd

    systemctl enable chronyd

### configure selinux policies for the webservers and nginx servers

    setsebool -P httpd_can_network_connect=1
    setsebool -P httpd_can_network_connect_db=1
    setsebool -P httpd_execmem=1
    setsebool -P httpd_use_nfs 1

### This section will insatll amazon efs utils for mounting the target on the Elastic file system

    git clone https://github.com/aws/efs-utils

    cd efs-utils

    yum install -y make

    yum install -y rpm-build

    make rpm 

    yum install -y  ./build/amazon-efs-utils*rpm

### Setting up self-signed certificate for the nginx instance

    sudo mkdir /etc/ssl/private

    sudo chmod 700 /etc/ssl/private

    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/ACS.key -out /etc/ssl/certs/ACS.crt

    sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048
 When you are done with setting up the self-signed certificate, you should see have s screen like the one below.

 ![](./images/nginx-sefl-signed-cert-done.png)

 * Verify self-signed cert is correctly installed

 ![](./images/certs.png)

### webserver ami installation

    yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm

    yum install -y dnf-utils http://rpms.remirepo.net/enterprise/remi-release-8.rpm

    yum install wget vim python3 telnet htop git mysql net-tools chrony -y

    systemctl start chronyd

    systemctl enable chronyd

### Configure selinux policies for the webservers and nginx servers

    setsebool -P httpd_can_network_connect=1
    setsebool -P httpd_can_network_connect_db=1
    setsebool -P httpd_execmem=1
    setsebool -P httpd_use_nfs 1

### This section will install amazon efs utils for mounting the target on the Elastic file system

    git clone https://github.com/aws/efs-utils

    cd efs-utils

    yum install -y make

    yum install -y rpm-build

    make rpm 

    yum install -y  ./build/amazon-efs-utils*rpm

### Setting up self-signed certificate for the apache webserver instance

    yum install -y mod_ssl

    openssl req -newkey rsa:2048 -nodes -keyout /etc/pki/tls/private/ACS.key -x509 -days 365 -out /etc/pki/tls/certs/ACS.crt

    vi /etc/httpd/conf.d/ssl.conf
![](./images/certs-2.png)

 ![](./images/apache-cert.png)

 #### References

[IP ranges](https://ipinfo.io/ips)

[Nginx reverse proxy server](https://www.nginx.com/resources/glossary/reverse-proxy-server/)

[Understanding ec2 user data](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html)

[Manually installing the Amazon EFS client](https://docs.aws.amazon.com/efs/latest/ug/installing-amazon-efs-utils.html#installing-other-distro)

[creating target groups for AWS Loadbalancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-target-groups.html)

[Self-Signed SSL Certificate for Apache](https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-apache-on-centos-8)

[Create a Self-Signed SSL Certificate for Nginx](https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-nginx-on-centos-7)

### Create AMIs from the 3 instances

![](./images/create-image.png)

![](./images/amis.png)

### Configure Load balancers and Target Groups

1. Create Target group for NGINX, tooling amd wordpress targets

![](./images/create-target-group.png)

![](./images/target-group-config-1.png)

![](./images/target-group-config-2.png)

![](./images/target-group-config-3.png)

![](./images/create-target-group-2.png)

![](./images/target-groups.png)

2. Configure Load balancers

![](./images/create-alb.png)

![](./images/alb.png)

![](./images/external-alb-config-1.png)

![](./images/external-alb-config-2.png)

![](./images/external-alb-config-3.png)

![](./images/external-alb-config-4.png)

![](./images/external-alb-config-5.png)

Repeat the same procedure for internal ALB, select wordpress as the default target and create a rule to send traffic to tooling if the headers match our specified parameters.

![](./images/albs.png)

![](./images/edit-rules.png)

![](./images/add-rule.png)

![](./images/add-condition.png)

![](./images/host-header.png)

![](./images/host-header-2.png)

![](./images/next.png)

![](./images/listerner-rules.png)

![](./images/albs-2.png)

### Create Launch Templates

From the created custom AMIs, create Launch templates for each of the instances
![](./images/create-launch-template-1.png)

![](./images/create-launch-template-2.png)

![](./images/create-launch-template-3.png)

![](./images/create-launch-template-4.png)

![](./images/create-launch-template-5.png)

Fill in the userdata for each launch template with the details from this [repo](https://github.com/lateef-taiwo/savvytek-project-config.git) and edit it with your details

![](./images/launch-templates.png)

### Create AutoScaling Groups

1. For Bastion

![](./images/asg.png)

![](./images/asg-config-1.png)

![](./images/asg-config-2.png)

![](./images/asg-config-3.png)

![](./images/asg-config-4.png)

![](./images/asg-config-5.png)

![](./images/asg-config-6.png)

2. For nginx

![](./images/asg-config-7.png)

![](./images/asg-config-8.png)

![](./images/asg-config-9.png)

3. For Wordpress

![](./images/asg-config-10.png)

![](./images/asg-config-11.png)

4. For Tooling-website

![](./images/asg-config-12.png)

![](./images/asg-config-13.png)

![](./images/asgs.png)

### Login into the RDS instance and create database for wordpress and tooling wordpress and tooling database

    mysql -h savvytek-database.c4scns6d3saq.eu-west-2.rds.amazonaws.com -u ACSadmin -p

    create database toolingdb; create database wordpressdb;

![](./images/db.png)

### Add Records to Route 53

Add records for `tooling.savvytek.online`. `www.tooling.savvytek.online`, `wordpress.savvytek.online`, `www.wordpress.savvytek.online` using an Alias point it to your internet facing load balancer.

![](./images/create-record.png)

![](./images/create-records-2.png)

![](./images/create-records-3.png)

![](./images/create-records-4.png)

![](./images/create-records-5.png)

### Test your websites.

* Tooling website

![](./images/tooling-0.png)

![](./images/tooling.png)

* Worpress website

![](./images/worpress-site.png)

![](./images/wordpress-site-1.png)

