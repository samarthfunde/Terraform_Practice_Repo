variable "myregion" {
  default = "ap-south-1"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "myami" {
  default = "ami-XXXXXXXXXXXXX"
}

variable "inst_type" {
  default = "t2.micro"
}

variable "key-name" {
  default = "public"

}
