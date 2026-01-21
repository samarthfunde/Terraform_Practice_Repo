provider "aws" {
    region = "ap-south-1"
}

# create security group to access nginx page 

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


resource "aws_instance" "my_ec2" {
  ami           = "ami-02b8269d5e85954ef"
  instance_type = "t2.micro"
  key_name      = "key-remote"

  vpc_security_group_ids = [ aws_security_group.mysg.id ]

  tags = {
    Name = "ec2"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("D:/key-remote.pem")
    host        = self.public_ip
  }

  # this is remote inside ec2 executuion commands means remote provisioner
  provisioner "remote-exec" {
    inline = [
      "sudo dnf update -y",
      "sudo dnf install nginx -y",
      "sudo systemctl start nginx.service",
      "sudo systemctl enable nginx.service"
    ]
  }
}

#to create null resosurces but just run execute commands in the local machine
  resource "null_resource" "local" {
    provisioner "local-exec" {
    command = <<EOT
    echo ${aws_instance.my_ec2.public_ip} >> public.txt
    echo ${aws_instance.my_ec2.id} >> ins_id.txt
    EOT
  }
  }
