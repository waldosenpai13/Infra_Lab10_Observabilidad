terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "4.2.0"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "6.41.0"
    }
  }
}

provider "aws" {
   profile= "waldorojas_13"
}
provider "docker" {
  # Configuration options
}
