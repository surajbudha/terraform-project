provider "aws" {
  access_key = "${var.access-key}"
  secret_key = "${var.secret-key}"
  region = "${var.region}"
}

resource "aws_instance" "Redis-Server" {
	ami           = "${var.image}"
	instance_type = "${var.instance-type}"
	security_groups = ["Linux","webserver","ftpserver","redis"]
	key_name      = "${var.ssh-key}"

	tags = {
		Name = "redis-server"
	}
}
resource "aws_instance" "dbserver" {
	ami = "${var.image}"
	instance_type = "${var.instance-type}"
	security_groups = ["Linux", "db_instance"]
	key_name = "${var.ssh-key}"
	tags = {
		Name = "DB-Server"
	}
}
resource "null_resource" "connect-redis" {
	provisioner "file" {
		source = "configuration"
		destination = "/home/ec2-user/"
		connection {
			host = "${aws_instance.Redis-Server.public_ip}"
			type     = "ssh"
			user     = "ec2-user"
			private_key = "${file("aws_new_private")}"
		}
	}
	provisioner "remote-exec" {
		inline = [
		"sudo amazon-linux-extras install redis4.0 -y",
		"sudo yum install php php-pear -y",
		"sudo pecl channel-update pecl.php.net",
		"sudo pecl install igbinary igbinary-devel redis",
		"sudo cp -rpv  /etc/redis.conf  /etc/redis.conf_bkup_`date +%F`",
		]
		connection {
			host = "${aws_instance.Redis-Server.public_ip}"
			type     = "ssh"
			user     = "ec2-user"
			private_key = "${file("aws_new_private")}"
		}
	}
}

resource "null_resource" "dbserver-config" {
	provisioner "file" {
		source = "configuration"
		destination = "/home/ec2-user/"
		connection {
			host = "${aws_instance.dbserver.public_ip}"
			type     = "ssh"
			user     = "ec2-user"
			private_key = "${file("aws_new_private")}"
		}
	}
	provisioner "remote-exec" {
		inline = [
		"sudo yum install mariadb-server mariadb mariadb-devel expect -y",
		"sudo systemctl enable mariadb.service",
		"sudo systemctl start mariadb.service",
		"chmod +x /home/ec2-user/configuration/configuredb.expect",
		"sudo expect /home/ec2-user/configuration/configuredb.expect",
		"sudo systemctl restart mariadb.service",
		]
		connection {
			host = "${aws_instance.dbserver.public_ip}"
			type     = "ssh"
			user     = "ec2-user"
			private_key = "${file("aws_new_private")}"
		}
	}
}