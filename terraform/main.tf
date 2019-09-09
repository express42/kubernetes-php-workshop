terraform {
  required_version = "~> 0.12.0" # фиксируем версию terraform
  backend "gcs" {
    bucket      = "userXX-terraformbucket" # бакет, где хранится конфигурация
    credentials = "account.json" # сервисный аккаунт для доступа к бакету
  }
}

provider "google" {
  credentials = "${file("account.json")}"
  project     = "${var.project}"
  region      = "${var.region}"
  zone        = "${var.zone}"
}

resource "google_storage_bucket" "terraformbucket" {
  name = "userXX-terraformbucket"
}

resource "google_container_cluster" "master_nodes" {
  name     = "${var.name}-kluster"
  location = "${var.region}"

  remove_default_node_pool = true
  initial_node_count       = "1"
  monitoring_service       = "none"
  logging_service          = "none"

  network_policy {
    enabled  = true
    provider = "CALICO"
  }

  ip_allocation_policy {
    use_ip_aliases = true
  }

  master_auth {
    client_certificate_config {
      issue_client_certificate = true
    }
  }
}

resource "google_container_node_pool" "worker_nodes" {
  name       = "${var.name}-workers-pool"
  cluster    = "${google_container_cluster.master_nodes.name}"
  location   = "${var.region}"
  node_count = "2"

  node_config {
    preemptible  = true
    machine_type = "n1-standard-1"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/monitoring.write",
    ]
  }
}

data "google_container_registry_repository" "gcr" {}