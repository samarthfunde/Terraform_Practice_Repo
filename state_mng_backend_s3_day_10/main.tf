# s3 backend for state lock
terraform {
  backend "s3" {
    bucket = "state-mng-bucket-terraform"
    region = "ap-south-1"
    key = "terraform.tfstate"
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "myweb" {
  ami = "ami-0ff5003538b60d5ec"
  instance_type = "t2.micro"
  key_name = "public"
  vpc_security_group_ids = [data.aws_security_group.mysg.id]
}

data "aws_security_group" "mysg" {
    name = "my-web"
}