output "nginx_public_ip" {
  description = "Adresse IP publique du serveur NGINX"
  value       = aws_instance.nginx.public_ip
}