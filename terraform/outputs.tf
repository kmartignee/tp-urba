output "frontend_public_ip" {
  description = "Adresse IP publique du serveur frontend"
  value       = aws_instance.frontend.public_ip
}

output "backend_private_ip" {
  description = "Adresse IP privée du serveur backend"
  value       = aws_instance.backend.private_ip
}

output "database_private_ip" {
  description = "Adresse IP privée du serveur de base de données"
  value       = aws_instance.database.private_ip
}