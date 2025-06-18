variable "region" {
  description = "Région AWS à utiliser"
  type        = string
  default     = "eu-west-3"
}

variable "vpc_id" {
  description = "ID du VPC existant"
  type        = string
  default     = "vpc-0306b25c3eefbf12d"
}

variable "subnet_cidr" {
  description = "CIDR block pour le subnet public"
  type        = string
  default     = "172.31.96.0/20"
}

variable "availability_zone" {
  description = "Zone de disponibilité pour le subnet"
  type        = string
  default     = "eu-west-3a"
}

variable "instance_type" {
  description = "Type d'instance EC2"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "ID de l'AMI pour l'instance EC2"
  type        = string
  default     = "ami-04ec97dc75ac850b1"
}

variable "nginx_name" {
    description = "Nom de l'instance Nginx"
    type        = string
    default     = "nginx-server"
}