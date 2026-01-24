variable "cidr_block" {}
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