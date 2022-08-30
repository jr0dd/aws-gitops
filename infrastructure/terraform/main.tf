terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.26.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.0.1"
    }
    sops = {
      source  = "carlpett/sops"
      version = "0.7.1"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "available" {}

data "http" "management_ip" {
  url = "http://ipv4.icanhazip.com"
}

locals {
  management_external_cidr = "${chomp(data.http.management_ip.body)}/32"
}
