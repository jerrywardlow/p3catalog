# Webserver Instance
resrouce "aws_instance" "web" {
    ami = "${var.ubuntu-ami}"
    instance_type = "t2.micro"
    subnet_id = "${aws_subnet.public.id}"
    vpc_security_group_ids = ["pass"]
    key_name = "${aws_key_pair.catalog.key_name}"
    tags = {
        name = "catalog-web"
    }
}
