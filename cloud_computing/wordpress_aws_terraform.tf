provider “aws” {
shared_credentials_file = "~/.aws/credentials"
	region = “us-east-2”
}

resource "aws_key_pair" "wnet-keypair" {
	key_name = "wnet-keypair"
	public_key = "ssh-rsa ..."
}

resource “aws_instance” “web” {
	ami = “ami-0dccf86d354af8ce3”
	key_name = “${aws_key_pair.wnet-keypair.key_name}”
	instance_type = “t2.micro”
}
