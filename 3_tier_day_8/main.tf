provider "aws" {
    region = var.myregion
}

##### Create VPC #####

resource "aws_vpc" "myvpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "custom-vpc"
  }
}

## Internet Gateway ##
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "my-igw"
  }
}

# to 1 create websubnet
resource "aws_subnet" "websubnet" {
  vpc_id = aws_vpc.myvpc.id
  availability_zone = "ap-south-1a"
  cidr_block = "10.0.0.0/20"
  tags = {
    Name = "web-subnet"
  }
}

# to 2 create appsubnet
resource "aws_subnet" "appsubnet" {
  vpc_id = aws_vpc.myvpc.id
  availability_zone = "ap-south-1b"
  cidr_block = "10.0.16.0/20"
  tags = {
    Name = "app-subnet"
  }
}

# to 3 create dbsubnet
resource "aws_subnet" "dbsubnet" {
  vpc_id = aws_vpc.myvpc.id
  availability_zone = "ap-south-1c"
  cidr_block = "10.0.32.0/20"
  tags = {
    Name = "db-subnet"
  }
}

# to create public route table
resource "aws_route_table" "pub-rt" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "pub-rt"
  }
}

# to create pvt-rt
resource "aws_route_table" "pvt-rt" {
  vpc_id = aws_vpc.myvpc.id
  # here we dont need to attach route because its by default private route table
  tags = {
    Name = "pvt-rt"
  }
}

# to assign web subnet to public route table
resource "aws_route_table_association" "web-assocation" {
  subnet_id = aws_subnet.websubnet.id
  route_table_id = aws_route_table.pub-rt.id
}

# to assign app subnet to private route table
resource "aws_route_table_association" "app-assocation" {
  subnet_id = aws_subnet.appsubnet.id
  route_table_id = aws_route_table.pvt-rt.id
}

# to assign db subnet to private route table
resource "aws_route_table_association" "db-assocation" {
  subnet_id = aws_subnet.dbsubnet.id
  route_table_id = aws_route_table.pvt-rt.id
}

## create security group
### web sg

resource "aws_security_group" "web-sg" {
  name = "websg"
  vpc_id = aws_vpc.myvpc.id
  ingress  {
    to_port = 22
    from_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    to_port = 80
    from_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  egress {
    to_port = 0
    from_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

##app sg
resource "aws_security_group" "app-sg" {
  name = "appsg"
  vpc_id = aws_vpc.myvpc.id
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
    cidr_blocks = ["10.0.0.0/16"] # only local vpc can access to the app
  }
  ingress {
    to_port = 80
    from_port = 80
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/20"] # accept the request only from websubnet ... so '10.0.0.0/20' this is websubnet cidr block
  }
}


##db sg
resource "aws_security_group" "db-sg" {
  name = "dbsg"
  vpc_id = aws_vpc.myvpc.id
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
    cidr_blocks = ["10.0.0.0/16"] # only local vpc can access to the db
  }
  ingress {
    to_port = 3306
    from_port = 3306
    protocol = "tcp"
    cidr_blocks = ["10.0.16.0/20"] # accept the request only from appsubnet ... so '10.0.16.0/20' this is appsubnet cidr block
  }
}

#### to create rds for database ####
# but we have to create subnet_group with two db subnets
#### create subnet Group for rds ####
resource "aws_db_subnet_group" "my-subnet_group" {
  name = "my-subnet-grp"
  subnet_ids = [aws_subnet.appsubnet.id, aws_subnet.dbsubnet.id]
}

#### web -server
resource "aws_instance" "webserver" {
  ami = var.myami
  instance_type = var.inst_type
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  subnet_id = aws_subnet.websubnet.id
  associate_public_ip_address = true  # i enable public ip for access web server
  tags = {
    Name = "webserver"
  }
}

#aap server

resource "aws_instance" "appserver" {
  ami = var.myami
  instance_type = var.inst_type
  vpc_security_group_ids = [ aws_security_group.app-sg.id ]
  subnet_id = aws_subnet.appsubnet.id
  tags = {
    Name = "appserver"
  }
}



# To create dbserver - rds
resource "aws_db_instance" "my-rds" {
  allocated_storage = 20
  engine = "mysql"
  engine_version = "8.0.40"
  db_name  = "mydb"
  username = "admin"
  password = "Pass$123"
  instance_class = "db.t3.micro"
  vpc_security_group_ids = [aws_security_group.db-sg.id]
  db_subnet_group_name = aws_db_subnet_group.my-subnet_group.id
  publicly_accessible    = false
  skip_final_snapshot = true  # i dont want to create snapshot with rds
}