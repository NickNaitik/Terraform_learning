// creating instance in VPC 
resource "aws_instance" "amq-master-instance" {

    ami = "ami-022ce6f32988af5fa" //RHEL9
    instance_type = "t3.micro"
    # subnet_id = aws_subnet.private-subnet-1.id
    subnet_id = aws_subnet.public-subnet-1.id
    vpc_security_group_ids = [aws_security_group.amq-sg.id]
    availability_zone = "ap-south-1a"
    associate_public_ip_address = true // This will give public IP
    key_name = aws_key_pair.name.key_name
    
    tags = {
        Name = "AMQ-MASTER-INSTANCE"
    }
}

resource "aws_instance" "amq-slave-instance" {

    ami = "ami-022ce6f32988af5fa" //RHEL9
    instance_type = "t3.micro"
    subnet_id = aws_subnet.public-subnet-2.id
    vpc_security_group_ids = [aws_security_group.amq-sg.id]
    availability_zone = "ap-south-1a"
    associate_public_ip_address = true // This will give public IP
    key_name = aws_key_pair.name.key_name
    
    tags = {
        Name = "AMQ-SLAVE-INSTANCE"
    }
}

resource "aws_instance" "amq-jumphost-instance" { //ssh -i primary_key ec2-user@AMQ-JUMPHOST-INSTANCE-IP

    ami = "ami-022ce6f32988af5fa" //RHEL9
    instance_type = "t3.micro"
    subnet_id = aws_subnet.public-subnet.id
    vpc_security_group_ids = [aws_security_group.amq-sg.id]
    availability_zone = "ap-south-1a"
    key_name = aws_key_pair.name.key_name

# Redhat document to follow - https://docs.redhat.com/fr/documentation/red_hat_amq_broker/7.10/html-single/getting_started_with_amq_broker/index#extracting-archive-linux-getting-started

# sudo yum install wget
# Java sudo - sudo yum install java-21-openjdk
#JAVA INSTALL - wget https://download.java.net/java/GA/jdk23.0.1/c28985cbf10d4e648e4004050f8781aa/11/GPL/openjdk-23.0.1_linux-x64_bin.tar.gz

# sudo yum install unzip

# RUN BELOW 3 COMMAND AT ONCE
# curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
# unzip awscliv2.zip
# sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update

# aws user configure  - "aws configure"

# You need to go in S3 and get the name of the folder
# download amq from s3 - aws s3 cp s3://tf-amq-project-5eab7ecc9bb8623f/amq/apache-artemis-2.38.0-bin.zip ~/

# Copy from EC2 - scp -i private_key -r downloads ec2-user@10.0.105.17:/home/ec2-user/  - Not Required

# This are wrong when first tried so ignore (

  # Master 
  # Create a file system on the EBS Volume - sudo mkfs -t ext4 /dev/nvme1n1
  # Create a mount point on the master broker - sudo mkdir /mnt/shared
  # Mount the EBS Volume - sudo mount /dev/nvme1n1 /mnt/shared
  # Verify the mount - df -h

  # Slave
  # Create a mount point on the slave broker - sudo mkdir /mnt/shared
  # Mount the EBS Volume - sudo mount /dev/nvme1n1 /mnt/shared
  # Verify the mount - df -h

#  )


# Create a dedicated user for amq and folder /opt/amq - sudo useradd -m -d /opt/amq amq-broker
# set amq-broker user password -- [ec2-user@ip-10-0-109-108 /]$ sudo passwd amq-broker
                        
# From  root location & using ec2-user user - sudo chown -R amq-broker:amq-broker opt

# Using  ec2-user create a directory with name amq-broker-directory inside ec2-user directory

# Run this command to move to zip to  directory [ec2-user@ip-10-0-109-108 ~]$ mv apache-artemis-2.38.0-bin.zip amq-broker-directory/

# Change owner of folders - sudo chown -R amq-broker:amq-broker amq-broker-directory 

# Go to amq-broker-directory & switch to amq-broker user - [ec2-user@ip-10-0-109-108 amq-broker-directory]$ sudo su amq-broker

# move folder to correct place to unzip - [amq-broker@ip-10-0-109-108 amq-broker-directory]$ mv apache-artemis-2.38.0-bin.zip /opt/amq
# unzip - unzip apache-artemis-2.38.0-bin.zip
# From opt/amq folder run command - ./apache-artemis-2.38.0/bin/artemis create amq-master-broker

# Form root location using amq-broker 
# To check status - "/opt/amq/amq-master-broker/bin/artemis-service" status
# To start - "/opt/amq/amq-master-broker/bin/artemis-service" start

# Change in bootstrap.xml - <binding name="artemis" uri="http://0.0.0.0:8161">
# Change in jolokia.xml - <allow-origin>*</allow-origin>
# From login.config remove guest access

# Create an EFS using terraform and attach it with correct security group and allow traffic 2049 port
# Using root user at root location create a directory - /mnt/shared-efs/data
# make amq user its owner - chown -R amq-broker:amq-broker /mnt/

# install helper program - sudo yum -y install nfs-utils
# Run command at root location using root user - sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport fs-057a27b50aa64905d.efs.ap-south-1.amazonaws.com:/ /mnt/shared-efs/data

#Change in master broker 
      # <paging-directory>/mnt/shared-efs/data/paging</paging-directory>

      # <bindings-directory>/mnt/shared-efs/data/bindings</bindings-directory>

      # <journal-directory>/mnt/shared-efs/data/journal</journal-directory>

      # <large-messages-directory>/mnt/shared-efs/data/large-messages</large-messages-directory>

      # <ha-policy>
      #    <shared-store>
      #       <master>
      #          <failover-on-shutdown>true</failover-on-shutdown>
      #       </master>
      #    </shared-store>
      # </ha-policy>

#Change in slave broker
      # <paging-directory>/mnt/shared/data/paging</paging-directory>

      # <bindings-directory>/mnt/shared/data/bindings</bindings-directory>

      # <journal-directory>/mnt/shared/data/journal</journal-directory>

      # <large-messages-directory>mnt/shared/data/large-messages</large-messages-directory>

      # <ha-policy>
      #    <shared-store>
      #       <slave>
      #         <failover-on-shutdown>true</failover-on-shutdown>
      #         <allow-failback>true</allow-failback>
      #         <restart-backup>true</restart-backup>
      #       </slave>
      #    </shared-store>
      # </ha-policy>

# status - "/opt/amq/amq-master-broker/bin/artemis-service" status

# Master SSH -  ssh -i "private_key" ec2-user@ec2-3-108-56-56.ap-south-1.compute.amazonaws.com
# Slave SSH - ssh -i "private_key" ec2-user@ec2-3-6-92-195.ap-south-1.compute.amazonaws.com

# Master -  http://ec2-3-108-56-56.ap-south-1.compute.amazonaws.com:8161/console/auth/login
# Slave -  http://ec2-3-6-92-195.ap-south-1.compute.amazonaws.com:8161/console/auth/login

# produce - "/opt/amq/amq-master-broker/bin/artemis" producer --destination helloworld --message-count 100 --url tcp://localhost:61616

# consume - "/opt/amq/amq-master-broker/bin/artemis" consumer --destination helloworld --message-count 50 --url tcp://localhost:61616


    tags = {
        Name = "AMQ-JUMPHOST-INSTANCE"
    }
}

resource "aws_ebs_volume" "multi_attach_ebs" {
  availability_zone = "ap-south-1a"
  size              = 5
  type = "io2"
  iops = 100
  multi_attach_enabled = true //We need to do multi attach if we want to attach with multiple instances
}


#Link Reference - https://dev.to/chinmay13/getting-started-with-aws-and-terraform-multi-attaching-ebs-volumes-with-terraform-7a3

resource "aws_volume_attachment" "ebs_att-master" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.multi_attach_ebs.id
  instance_id = aws_instance.amq-master-instance.id
}

resource "aws_volume_attachment" "ebs_att-slave" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.multi_attach_ebs.id
  instance_id = aws_instance.amq-slave-instance.id
}

resource "aws_ebs_encryption_by_default" "example" {
  enabled = true
}

resource "aws_ec2_instance_connect_endpoint" "example" {
  subnet_id = aws_subnet.private-subnet-1.id

  tags = {
    Name = "AMQ-MASTER-INSTANCE-ENDPOINT"
  }
}

#java location - cd ../../usr/lib/jvm/java-21-openjdk-21.0.5.0.10-3.el9.x86_64/bin/