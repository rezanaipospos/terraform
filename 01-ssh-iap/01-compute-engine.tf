resource "google_service_account" "this" {
  project = var.project_id
  account_id   = var.sa_name
  display_name = var.sa_name
}

resource "google_project_iam_member" "this" {
  for_each = toset(var.sa_roles)
  member  = "serviceAccount:${google_service_account.this.email}"
  project = var.project_id
  role    = each.value
}

resource "google_compute_address" "bastion_host_internal_ip" {
  name         = "${var.name}-internal-ip"
  region       = var.region
  address_type = "INTERNAL"
  project      = var.project_id
  subnetwork   = var.vpc_subnet_name
}

resource "google_compute_instance" "this" {
  project      = var.project_id
  name         = var.name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.machine_os
      size = var.disk_size
      type = var.disk_type
    }
  }

  network_interface {
    network               = var.vpc_name
    subnetwork            = var.vpc_subnet_name
    subnetwork_project    = var.project_id
    network_ip = google_compute_address.bastion_host_internal_ip.address
  }
  tags = var.network_tags

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.this.email
    scopes = var.sa_scopes
  }
  depends_on = [google_compute_address.bastion_host_internal_ip]
}
