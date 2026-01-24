## security group for web-sg
resource "aws_security_group" "web-sg" {
  name = "websg"
  vpc_id = var.vpc-id
  description = "to attach with webserver"
  ingress {
    to_port = 22
    from_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    to_port = 80
    from_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    to_port = 0
    from_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


## security group for app-sg
resource "aws_security_group" "app-sg" {
  name = "appsg"
  vpc_id = var.vpc-id
  description = "to attach with appserver"
  ingress {
    to_port = 22
    from_port = 22
    protocol = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  ingress {
    to_port = 80
    from_port = 80
    protocol = "tcp"
    cidr_blocks = [var.web_cidr]
  }
  egress {
    to_port = 0
    from_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


## security group for app-sg
resource "aws_security_group" "db-sg" {
  name = "dbsg"
  vpc_id = var.vpc-id
  description = "to attach with dbserver"
  ingress {
    to_port = 22
    from_port = 22
    protocol = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  ingress {
    to_port = 80
    from_port = 80
    protocol = "tcp"
    cidr_blocks = [var.db_cidr]
  }
  egress {
    to_port = 0
    from_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "web-sg-id" {
  value = aws_security_group.web-sg.id
}

output "app-sg-id" {
  value = aws_security_group.app-sg.id
}

output "db-sg-id" {
  value = aws_security_group.db-sg.id
}