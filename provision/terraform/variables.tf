variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "us-west-2"
}

variable "amis" {
  type = "map"
  default = {
    us-east-1 = "ami-81365496"
    us-west-1 = "ami-05105d65"
    us-west-2 = "ami-9ece19fe"
  }
}
