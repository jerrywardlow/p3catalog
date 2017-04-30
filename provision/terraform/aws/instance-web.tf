# Web server Instance
resource "aws_instance" "web" {
    ami = "${data.aws_ami.ubuntu.id}"
    instance_type = "t2.micro"
    subnet_id = "${aws_subnet.public.id}"
    vpc_security_group_ids = ["aws_security_group.web.id"]
    key_name = "${aws_key_pair.catalog.key_name}"

    tags {
        name = "catalog-web"
    }
}
