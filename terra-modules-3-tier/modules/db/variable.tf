variable "storage" {
 default = 20
}

variable "username" {
  default = "admin"
}

variable "password" {
  default = "Pass$123"
}

variable "db-ins-type" {
  default = "db.t3.micro"
}

variable "db-sg-id" { }
variable "sub-grp-id" { }