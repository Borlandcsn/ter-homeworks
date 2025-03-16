terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
  required_version = ">=1.8.4" # Требуемая версия Terraform
}

provider "docker" {}
provider "random" {}

# Создание случайной строки
resource "random_password" "random_string" {
  length      = 16
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}

# Создание Docker-образа
resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = true
}

# Создание Docker-контейнера
resource "docker_container" "nginx" {
  image = docker_image.nginx.name
  name  = "example_${random_password.random_string.result}"

  ports {
    internal = 80
    external = 9090
  }
}
