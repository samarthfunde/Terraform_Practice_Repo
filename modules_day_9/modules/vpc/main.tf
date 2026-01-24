#### to create VPC
resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr_block
  tags = {
    Name = "custom_vpc"
  }
}

## to create web subnet
resource "aws_subnet" "web-subnet" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = var.web_cidr
  tags = {
    Name = "websubnet"
  }
  map_public_ip_on_launch = true # if the servers launch inside the subnet then assign the public ip to that servers
  availability_zone = var.web-az
}

## to create app subnet
resource "aws_subnet" "app-subnet" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = var.app_cidr
  tags = {
    Name = "appsubnet"
  }
  map_public_ip_on_launch = false # if the servers launch inside the subnet then dont assign the public ip to that servers
  availability_zone = var.app-az
}

## to create db subnet
resource "aws_subnet" "db-subnet" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = var.db_cidr
  tags = {
    Name = "dbsubnet"
  }
  map_public_ip_on_launch = false # if the servers launch inside the subnet then dont assign the public ip to that servers
  availability_zone = var.db-az
}

## to create subnet-group
resource "aws_db_subnet_group" "my-subnet-group" {
  name = "my-subnet-grp"
  subnet_ids = [aws_subnet.app-subnet.id, aws_subnet.db-subnet.id]
}


## to create internet gateway
resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "myigw"
  }
}


output "vpc_id" {
    value = aws_vpc.myvpc.id
}

output "web-sub-id" {
  value = aws_subnet.web-subnet.id
}

output "app-sub-id" {
  value = aws_subnet.app-subnet.id
}

output "db-sub-id" {
  value = aws_subnet.db-subnet.id
}

output "subnet-group-id" {
  value = aws_db_subnet_group.my-subnet-group.id
}