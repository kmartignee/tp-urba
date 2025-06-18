variable "region" {
  description = "Région AWS à utiliser"
  type        = string
  default     = "eu-west-3"
}

variable "vpc_id" {
  description = "CIDR block pour le VPC"
  type        = string
  default     = "vpc-0306b25c3eefbf12d"
}

variable "subnet_cidr" {
  description = "CIDR block pour le subnet public"
  type        = string
  default     = "10.0.1.0/24"
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
  default     = "ami-0fdf333b744e31bde"
}

variable "ssh_key_name" {
  description = "Nom de la clé SSH à utiliser"
  type        = string
  default     = "ma-cle-ssh"
}