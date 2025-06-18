output "nginx_public_ip" {
  description = "Adresse IP publique du serveur NGINX"
  value       = aws_instance.nginx.public_ip
}

output "vpc_id" {
  description = "ID du VPC créé"
  value       = aws_vpc.main.id
}