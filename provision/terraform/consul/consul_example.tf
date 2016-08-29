provider "aws" {
    region = "us-west-2"
}

module "consul" {
    source = "github.com/hasicorp/consul/terraform/aws"

    key_name = "id_rsa"
    key_path = "~/.ssh/id_rsa"
    region = "us-west-2"
    servers = "3"
}
