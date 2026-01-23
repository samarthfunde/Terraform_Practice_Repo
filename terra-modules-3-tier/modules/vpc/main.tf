resource "aws_vpc" "myvpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "custom-vpc"
  }
}
resource "aws_internet_gateway" "igw" {
    vpc_id =  aws_vpc.myvpc.id
    tags = {
      Name = "my-igw"
    }
}

output "vpc_id" {
    value = aws_vpc.myvpc.id 
}

# to create websubnet
resource "aws_subnet" "websubnet" {
   vpc_id = aws_vpc.myvpc.id
   availability_zone = var.web-az
   cidr_block = var.web_cidr
   tags = {
     Name = "web-subnet"
   }
}

output "web-sub-id" {
  value = aws_subnet.websubnet.id
}

#to create appsubnet
resource "aws_subnet" "appsubnet" {
   vpc_id = aws_vpc.myvpc.id
   availability_zone = var.app-az
   cidr_block = var.app_cidr
   tags = {
     Name = "app-subnet"
   }
}

output "app-sub-id" {
  value = aws_subnet.appsubnet.id
}

#to create dbsubnet
resource "aws_subnet" "dbsubnet" {
   vpc_id = aws_vpc.myvpc.id
   availability_zone = var.db-az
   cidr_block = var.db_cidr
   tags = {
     Name = "db-subnet"
   }
}

output "db-sub-id" {
  value = aws_subnet.dbsubnet.id
}

#To create public_RT
resource "aws_route_table" "pub-rt" {
  vpc_id = aws_vpc.myvpc.id
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "pub-RT"
  }
}
 
#to create pvt-RT
resource "aws_route_table" "pvt-rt" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "pvt-RT"
  }
}
 
#to attach public-RT to websubnet
resource "aws_route_table_association" "web-association" {
  subnet_id = aws_subnet.websubnet.id
  route_table_id = aws_route_table.pub-rt.id
}
 
#to attach RT with appsubnet
 
resource "aws_route_table_association" "app-association" {
  subnet_id = aws_subnet.appsubnet.id
  route_table_id = aws_route_table.pvt-rt.id
}
 
#to attach pvt RT to dbsubnet
 
resource "aws_route_table_association" "db-association" {
  subnet_id = aws_subnet.dbsubnet.id
  route_table_id = aws_route_table.pvt-rt.id
}

# to create subnet group
resource "aws_db_subnet_group" "my-subnet-group" {
   name = "my-subnet-grp"
   subnet_ids = [aws_subnet.appsubnet.id, aws_subnet.dbsubnet.id]
}

output "sub-grp-id" {
  value = aws_db_subnet_group.my-subnet-group.id
}