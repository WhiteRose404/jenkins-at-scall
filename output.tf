output "master" {
  value = "ssh -i cloud_guru ubuntu@${aws_instance.master.public_ip}"
}

output "slaves" {
  value = aws_instance.slaves.*.public_ip
}