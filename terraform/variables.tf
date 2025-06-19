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

variable "ma_cle_ssh" {
  description = "Nom de la clé SSH pour accéder aux instances"
  type        = string
  default     = "ma-cle-ssh"
}

variable "instance_type_db" {
  description = "Type d'instance pour la base de données"
  type        = string
  default     = "t2.micro"
}