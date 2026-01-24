# To create dbserver - rds
resource "aws_db_instance" "my-rds" {
  allocated_storage = var.storage
  engine = "mysql"
  engine_version = "8.0.40"
  db_name  = var.dbname
  username = var.username
  password = var.password
  instance_class = var.db-ins-type
  vpc_security_group_ids = [var.db-sg-id]
  db_subnet_group_name = var.sub-grp-id
  publicly_accessible    = false
  skip_final_snapshot = true  # i dont want to create snapshot with rds
}

output "end-point" {
  value = aws_db_instance.my-rds.endpoint
}