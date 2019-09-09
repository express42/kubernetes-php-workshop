output "gcr_location" {
  value = "${data.google_container_registry_repository.gcr.repository_url}"
}
