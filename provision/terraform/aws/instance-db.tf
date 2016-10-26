# DB server Instance
resource "aws_instance" "db" {
    ami = "${var.ubuntu-ami}"
    instance_type = "t2.micro"
    subnet_id = "${aws_subnet.private.id}"
    vpc_security_group_ids = ["aws_security_group.db.id"]
    key_name = "${aws_key_pair.catalog.key_name}"

    tags {
        name = "catalog-db"
    }
}
