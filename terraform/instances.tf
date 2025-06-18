resource "aws_instance" "nginx" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.ssh_key_name
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]

  tags = {
    Name = "nginx-server"
  }

  provisioner "local-exec" {
    command = "echo '[nginx]\n${self.public_ip} ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/${var.ssh_key_name}.pem' > ../ansible/inventory.ini"
  }

  provisioner "local-exec" {
    command = "cd ../ansible && ansible-playbook -i inventory.ini nginx_playbook.yml"
  }
}