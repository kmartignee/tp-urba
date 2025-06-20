resource "aws_instance" "frontend" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.frontend_sg.id]
  key_name               = var.ma_cle_ssh
  metadata_options {
    http_tokens = "required"
    http_endpoint = "enabled"
  }

  tags = {
    Name = "frontend-server"
    Tier = "frontend"
  }
  
  provisioner "local-exec" {
    command = "echo ${self.public_ip} > front-ip.txt"
  }
}

resource "aws_instance" "backend" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private.id
  associate_public_ip_address = false
  vpc_security_group_ids = [aws_security_group.backend_sg.id]
  key_name               = var.ma_cle_ssh
  metadata_options {
    http_tokens = "required"
    http_endpoint = "enabled"
  }

  tags = {
    Name = "backend-server"
    Tier = "backend"
  }
  
  provisioner "local-exec" {
    command = "echo ${self.private_ip} > back_ip.txt"
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