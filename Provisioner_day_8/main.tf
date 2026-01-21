########################
# AWS PROVIDER
########################
provider "aws" {
  region = "ap-south-1"
}

########################
# SECURITY GROUP
# Allow SSH (22) and HTTP (80)
########################
resource "aws_security_group" "mysg" {
  name = "my-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

########################
# EC2 INSTANCE (Ubuntu)
########################
resource "aws_instance" "my_ec2" {
  ami           = "ami-019715e0d74f695be" # Ubuntu AMI (ap-south-1)
  instance_type = "t2.micro"
  key_name      = "key-remote"

  vpc_security_group_ids = [aws_security_group.mysg.id]

  tags = {
    Name = "ec2"
  }

  ########################
  # 1) Local_exec PROVISIONER
  ########################
  provisioner "local-exec" {
    command = "echo ${self.public_ip} >> pub_ip.txt && echo ${self.id} >> ins_id.txt"
  }


  ########################
  # 2) FILE PROVISIONER
  # Copies script.sh to EC2
  ########################
  provisioner "file" {
    source      = "script.sh"
    destination = "/home/ubuntu/script.sh"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("D:/key-remote.pem")
      host        = self.public_ip
    }
  }
}

########################
# NULL RESOURCE
# 3) remote _Exec Provisioner
# Executes script on EC2
########################
resource "null_resource" "remote" {

  depends_on = [aws_instance.my_ec2]

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/script.sh",
      "/home/ubuntu/script.sh"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("D:/key-remote.pem")
      host        = aws_instance.my_ec2.public_ip
    }
  }
}
