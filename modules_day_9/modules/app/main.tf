## app server

resource "aws_instance" "app-server" {
  ami = var.myami
  instance_type = var.ins-type
  key_name = var.mykey
  subnet_id = var.app-sub-id
  vpc_security_group_ids = [var.app-sg-id]
}

output "app-inst-ip" {
   value = aws_instance.app-server
}