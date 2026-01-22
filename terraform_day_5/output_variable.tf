output "public_ip" {
  value = aws_instance.web-instance.public_ip
}

output "instace_type" {
  value = aws_instance.web-instance.instance_type
}

output "ins_id" {
  value = aws_instance.web-instance.id
}