variable "my-region" {
  default = "ap-south-1"
}

variable "vpc_cidr" {}
variable "web_cidr" {}
variable "web-az" {
    default = "ap-south-1a"
}
variable "app_cidr" {}
variable "app-az" {
    default = "ap-south-1b"
}
variable "db_cidr" {}
variable "db-az" {
    default = "ap-south-1c"
}

variable "ins-type" {}
variable "myami" {}
variable "mykey" {}

variable "user" {}
variable "password" {}
variable "storage" {}
variable "db-ins-type" {}
variable "dbname" {
  
}