terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.46.0"
    }
  }
}

provider "aws" {
    profile = "cloud_guru"
    region  = "us-east-1"
}


locals {
  instance_type = "t3.small"
}

resource "aws_instance" "master" {
  ami = data.aws_ami.ubuntu.id
  instance_type = local.instance_type
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  key_name = aws_key_pair.my_key.key_name
}

resource "aws_instance" "slaves" {
  count = 10
  ami = data.aws_ami.ubuntu.id
  instance_type = local.instance_type
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  key_name = aws_key_pair.my_key.key_name
}

resource "aws_security_group" "allow_ssh" {
  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
      from_port = 8080
      to_port = 8080
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}


resource "aws_key_pair" "my_key" {
    key_name = "cloud_guru"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCx9jEvi+OdBaEF7/8dchqGYHLCnbD5Z4xfAcqzL6EQdxW4usH9L8kk1z+1dG3qTz9KRNDFF80AFP9sovxBCf8IMUXvZDJu3pjvIF72WLS7yEK384h7AwMdWGGJfy7K1saDW7euNUO0r0HoRnSD1GpLIw2B09dm9Xj662FGUlowDys63y6bKuR4DO+lZ0Z7gL5kYhKaFembCe1BaDKBpIMnxWV3Py6Pz1yUGw51/bP4BS8LApVygQang2rTkvnpYWba2e+1mWVfnTL3Ui4JS4thQiR4GKAva2BwulES3/zhgIjBBixW/H7liZmGk1GHhr3HUp8yY1FkmqslBqEkWFESuTLWgdMUZF9qQE/ZUdUmoglCApNu32aw+gFY6IgIxfLPzXY84evn63rjgJnmf7OtRZMtt/Ax80JtWe9J1x/HXDJLed0YptnSsUTmIKhf2cBxL23onOcJv9fnXrn9zV5xjYPULCztN3YQHoHuO76JStii4w/HlWMhgJToSj/0eG8= yoedd@casa-os-50"
}