variable "name" {
  default = "<SERVICE_NAME>"
}

# Backend

terraform {
  backend "s3" {
    bucket = "mirriad-platform-state"
    region = "eu-west-1"
    key    = "services/<SERVICE_NAME>/<SERVICE_NAME>.tfstate"
  }
}

# Providers

provider "aws" {
  region = "eu-west-1"
}

provider "vault" {
  version = "2.24"
}

provider "rancher" {
  api_url    = "https://rancher.mirriad.com"
  access_key = "${data.vault_generic_secret.rancher_auth.data["access_key"]}"
  secret_key = "${data.vault_generic_secret.rancher_auth.data["secret_key"]}"
}

# Sources

data "vault_generic_secret" "rancher_auth" {
  path = "secret/rancher"
}

data "vault_generic_secret" "secrets" {
  path = "secret/${var.name}"
}

data "external" "git_commit" {
  program = ["git", "log", "-n", "1", "--pretty={\"id\": \"%H\"}"]
}

resource "rancher_stack" "<SERVICE_NAME>-stack" {
  name            = "${var.name}"
  environment_id  = "${data.vault_generic_secret.rancher_auth.data["environment_id"]}"
  scope           = "user"
  start_on_create = true
  finish_upgrade  = true
  docker_compose  = "${file("docker-compose.rancher.yml")}"

  environment {

    GIT_COMMIT   = "${data.external.git_commit.result.id}"
    ENV         = "${terraform.workspace}"
    DB_HOSTNAME = "${var.env_db_hostname[terraform.workspace]}"
    DB_USERNAME = "${lookup(data.vault_generic_secret.secrets.data, "DB_USERNAME")}"
    DB_PASSWORD = "${lookup(data.vault_generic_secret.secrets.data, "DB_PASSWORD")}"

	PLATFORM_BASEURI = "${var.base_url[{terraform.workspace}]"

  }
}

variable "env_db_hostname" {
  type = "map"

  default = {
    d01 = "rds-d01-platform.cnttbcfsmwb5.eu-west-1.rds.amazonaws.com"
    d02 = "rds-d02-platform.cnttbcfsmwb5.eu-west-1.rds.amazonaws.com"
    t01 = "rds-t01-platform.cnttbcfsmwb5.eu-west-1.rds.amazonaws.com"
    t02 = "rds-t02-platform.cnttbcfsmwb5.eu-west-1.rds.amazonaws.com"
    s01 = "rds-s01-platform.cnttbcfsmwb5.eu-west-1.rds.amazonaws.com"
    p01 = "rds-p01-platform.cnttbcfsmwb5.eu-west-1.rds.amazonaws.com"
  }
}

variable "base_url" {
  type = "map"

  default = {
    d01 = "https://d01-marketplace.mirriad.com"
    d02 = "https://d02-marketplace.mirriad.com"
    t01 = "https://t01-marketplace.mirriad.com"
    t02 = "https://t02-marketplace.mirriad.com"
    s01 = "https://staging-marketplace.mirriad.com"
    p01 = "https://marketplace.mirriad.com"
  }
}

