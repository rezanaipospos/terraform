terraform {
  required_version = ">= 1.7.4"

  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.6.0"
    }
  }

  backend "gcs" {
    bucket  = "tf-infra-as-code"
    prefix = "tutorial/devops/iap/"
    impersonate_service_account = "sa-impersonate@devops.iam.gserviceaccount.com"
  }
}
