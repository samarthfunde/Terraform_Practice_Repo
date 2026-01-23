resource "aws_instance" "webserver" {
  ami = var.myami
  instance_type = var.ins_type
  vpc_security_group_ids = [var.web-sg-id]
  subnet_id = var.web-sub-id
  associate_public_ip_address = true
  tags = {
    Name = "webserver"
  }
 }