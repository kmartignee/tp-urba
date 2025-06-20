output "nginx_app_ip" {
  value = aws_instance.nginx_app.public_ip
  description = "Adresse IP publique du serveur Nginx (front + back)"
}

output "database_ip" {
  value = aws_instance.database.private_ip
  description = "Adresse IP privée du serveur de base de données"
}