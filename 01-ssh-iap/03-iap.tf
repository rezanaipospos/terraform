# Set metadata to enable OS Login
resource "google_compute_project_metadata" "project_metadata" {
  project = var.project_id
  metadata = {
    "enable-oslogin" = "TRUE"
  }
}

# Create a new service account
resource "google_service_account" "sa_iap_user" {
  project = var.project_id
  account_id   = "sa-iap-user"
  display_name = "IAP User (Non Root) Service Account"
}

# Assign roles to the service account
resource "google_project_iam_member" "compute_os_login" {
  project = var.project_id
  role   = "roles/compute.osLogin"
  member = "serviceAccount:${google_service_account.sa_iap_user.email}"
}

# Assign IAP tunnel user to impersonate service account
resource "google_project_iam_member" "iap_secured_tunnel_user" {
  project = var.project_id
  role   = "roles/iap.tunnelResourceAccessor"
  member = "serviceAccount:${google_service_account.sa_iap_user.email}"
}

#Compute Engine Service Account
data "google_service_account" "bastion_host" {
  project = var.project_id
  account_id = google_service_account.this.email
}

# Add sa-iap-admin as principal to the default service account with Service Account User role
resource "google_service_account_iam_member" "sa_bastion_host" {
  service_account_id = data.google_service_account.bastion_host.id
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${google_service_account.sa_iap_user.email}"
}

# Add user to sa-iap-admin as a principal with Service Account Token Creator role
resource "google_service_account_iam_member" "user_token_creator" {
  service_account_id = google_service_account.sa_iap_user.id
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "user:rezanaipospos@gmail.com"  # Replace with the user's email
}
