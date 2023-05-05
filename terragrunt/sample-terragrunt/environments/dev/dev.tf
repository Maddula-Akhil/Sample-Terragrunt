terraform {
  required_version = ">= 1.0"

  cloud {
    organization = "Name of the Organization"

    workspaces {
      name = "Name of the dev workspace"
    }
  }
}
