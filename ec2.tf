provider "aws" {
  access_key = "add-here-your-access-key"
  secret_key = "add-here-your-secret-key"
  region     = "ap-south-1"
}
resource "aws_instance" "myec2" {
  ami           = "ami-add-here-ami-id"
  instance_type = "t2.micro"
  count = 1
  tags = {
    Name = "my_ec2"
  }

}