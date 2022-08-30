variable "aws_region" {
  description = "AWS region to launch servers"
  default = "us-east-1"
}

variable "az_count" {
  description = "Number of AZs to cover in a given AWS region"
  default     = "2"
}

variable "key_name" {
  description = "Name of AWS key pair"
}

variable "instance_type" {
  default     = "t2.micro"
  description = "AWS instance type"
}

variable "service_desired" {
  description = "Desired numbers of instances in the ecs service"
  default     = "1"
}

variable "aws_ami" {
  description = "Image to deploy"
  # ubuntu 22.04
  default = "ami-052efd3df9dad4825"
}

variable "admin_cidr_ingress" {
  description = "CIDR to allow tcp/22 ingress to EC2 instance"
}

variable "cluster_name" {
  description = "Kubernetes cluster name"
  default = "whalestream-staging"
}
