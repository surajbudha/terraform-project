variable region {
	default = "us-east-1"
}

variable image {
	default = "ami-0b69ea66ff7391e80"
}

variable ssh-key {
	default = "aws_new_private"
}

variable instance-type {
	default = "t2.micro"
}

variable postinstall-script {
	default = "D:/terraform/postinstall.sh"
}
variable root_password {
	default = "D:/terraform/test_aws_home_priv"
}
variable user {
	default = "ec2-user"
}