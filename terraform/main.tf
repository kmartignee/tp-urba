# main.tf - Configuration pour déployer une instance EC2 avec NGINX

provider "aws" {
  region = "eu-west-3"  # Région Paris
}

# VPC et réseau
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "nginx-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-3a"
  map_public_ip_on_launch = true
  tags = {
    Name = "nginx-public-subnet"
  }
}

# Groupe de sécurité
resource "aws_security_group" "nginx_sg" {
  name        = "nginx-sg"
  description = "Autoriser HTTP, HTTPS et SSH"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Internet Gateway et routage
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Instance EC2
resource "aws_instance" "nginx" {
  ami           = "ami-0fdf333b744e31bde"  # Amazon Linux 2 dans eu-west-3
  instance_type = "t2.micro"
  key_name      = "ma-cle-ssh"  # Remplacer par votre clé SSH
  subnet_id     = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]

  tags = {
    Name = "nginx-server"
  }

  # Fichier d'inventaire Ansible
  provisioner "local-exec" {
    command = "echo '[nginx]\n${self.public_ip} ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/ma-cle-ssh.pem' > inventory.ini"
  }

  # Exécution du playbook Ansible après création
  provisioner "local-exec" {
    command = "ansible-playbook -i inventory.ini nginx_playbook.yml"
  }
}

output "nginx_public_ip" {
  value = aws_instance.nginx.public_ip
}