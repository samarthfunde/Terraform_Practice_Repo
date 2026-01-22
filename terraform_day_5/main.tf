
resource "aws_instance" "web-instance" {
  ami               = var.ami_id
  instance_type     = var.instance_types["dev"]
  key_name          = var.key_name
  availability_zone = var.my_az[0]
  subnet_id = var.subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.websg.id]
  tags = {
    Name = var.instance_name
  }

# we use user_data if we have to add some packages or files in side the instance durong execution
   user_data = <<-EOF
          #!/bin/bash
          apt update
          apt install nginx -y
          systemctl start nginx
          cd /var/www/html/
          echo "<h1>Shree Swami Samarth!</h1>" > index.html
                EOF
}


resource "aws_security_group" "websg" {
 
  ingress {
     to_port = 80
     from_port = 80
     protocol = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
     to_port = 22
     from_port = 22
     protocol = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
  }
  egress{
    to_port = 0
    from_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}