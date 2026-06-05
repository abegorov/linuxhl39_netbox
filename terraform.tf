terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.9"
    }
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.206"
    }
  }
  required_version = "~> 1.14"
}
