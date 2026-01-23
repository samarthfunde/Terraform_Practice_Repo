#to create web-sg
resource "aws_security_group" "web-sg" {
  name = "websg"
  description = "To attach to webserver"
  vpc_id = var.vpc_id
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
 
#to create app-sg
resource "aws_security_group" "app-sg" {
  name = "appsg"
  description = "To attach to appserver"
  vpc_id = var.vpc_id
  egress {
    to_port = 0
    from_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
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
}
 
#to create db-sg
resource "aws_security_group" "db-sg" {
  name = "dbsg"
  description = "To attach to dbserver"
  vpc_id = var.vpc_id
  egress {
    to_port = 0
    from_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    to_port = 22
    from_port = 22
    protocol = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  ingress {
    to_port = 3306
    from_port = 3306
    protocol = "tcp"
    cidr_blocks = [var.app_cidr]
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