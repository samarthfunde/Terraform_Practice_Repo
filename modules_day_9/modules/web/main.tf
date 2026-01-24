## web server

resource "aws_instance" "web-server" {
  ami = var.myami
  instance_type = var.ins-type
  key_name = var.mykey
  subnet_id = var.web-sub-id
  vpc_security_group_ids = [var.web-sg-id]
}

output "web-inst-ip" {
   value = aws_instance.web-server
}