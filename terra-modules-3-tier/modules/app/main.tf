resource "aws_instance" "appserver" {
  ami = var.myami
  instance_type = var.ins_type
  vpc_security_group_ids = [var.app-sg-id]
  subnet_id = var.app-sub-id
  associate_public_ip_address = false
  tags = {
    Name = "appserver"
  }
 }