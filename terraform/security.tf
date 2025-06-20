# Groupe de sécurité pour l'instance Nginx (front + back)
resource "aws_security_group" "app_sg" {
  name        = "app-security-group"
  vpc_id      = aws_vpc.main.id

  # Autoriser le trafic HTTP entrant
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Acces HTTP"
  }

  # Autoriser le trafic HTTPS entrant
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Acces HTTPS"
  }

  # Autoriser SSH pour l'administration (restreindre dans un environnement de production)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Acces SSH"
  }

  # Autoriser le trafic Node.js backend (si besoin d'un accès direct)
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "API Node js"
  }

  # Permettre tout le trafic sortant
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Tout le trafic sortant"
  }

  tags = {
    Name = "app-security-group"
  }
}

# Groupe de sécurité pour la base de données
resource "aws_security_group" "database_sg" {
  name        = "database-security-group"
  vpc_id      = aws_vpc.main.id

  # Autoriser le trafic MySQL/PostgreSQL uniquement depuis le serveur d'application
  ingress {
    from_port       = 3306 # MySQL (remplacer par 5432 pour PostgreSQL si nécessaire)
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
    description     = "Acces base de donnees depuis l application"
  }

  # Autoriser SSH pour l'administration (idéalement à restreindre davantage)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Acces SSH"
  }

  # Permettre tout le trafic sortant
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Tout le trafic sortant"
  }

  tags = {
    Name = "database-security-group"
  }
}