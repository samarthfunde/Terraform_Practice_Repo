variable "region" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "instance_types" {
  type = map(string)
  default = {
    dev  = "t2.micro"
    qa   = "t2.small"
    prod = "t2.medium"
  }
}

variable "key_name" {
  type = string
}

variable "instance_name" {
  type = string
}

variable "my_az" {
  type    = list(string)
  #default = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}

variable "subnet_id" {}