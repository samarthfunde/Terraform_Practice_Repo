#To create dbserver
resource "aws_db_instance" "my-rds" {
  allocated_storage = var.storage
  engine = "mysql"
  engine_version = "8.0"
  username = var.username
  password = var.password
  instance_class = var.db-ins-type
  vpc_security_group_ids = [var.db-sg-id]
  db_subnet_group_name = var.sub-grp-id
  skip_final_snapshot  = true
}  