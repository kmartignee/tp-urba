resource "aws_instance" "nginx_app" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  key_name               = var.ma_cle_ssh
  metadata_options {
    http_tokens = "required"
    http_endpoint = "enabled"
  }

  tags = {
    Name = "nginx-app-server"
    Tier = "application"
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > app_ip.txt"
  }
}

resource "aws_instance" "database" {
  ami                    = var.ami_id
  instance_type          = var.instance_type_db
  subnet_id              = aws_subnet.private.id
  associate_public_ip_address = false
  vpc_security_group_ids = [aws_security_group.database_sg.id]
  key_name               = var.ma_cle_ssh
  metadata_options {
    http_tokens = "required"
    http_endpoint = "enabled"
  }

  tags = {
    Name = "database-server"
    Tier = "database"
  }

  provisioner "local-exec" {
    command = "echo ${self.private_ip} > database_ip.txt"
  }
}