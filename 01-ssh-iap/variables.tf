variable "project_id" {default = "nsr-devops"}
variable "region" {default = "asia-southeast1"}
variable "zone" {default = "asia-southeast1-a"}
variable "name" {default = "bastion-host"}
variable "machine_type" {default = "n2-standard-2"}
variable "machine_os" {default = "ubuntu-os-cloud/ubuntu-2204-lts"}
variable "disk_type" {default = "pd-balanced"}
variable "disk_size" {default = 100}
variable "vpc_name" {default = "devops-vpc"}
variable "vpc_subnet_name" {default = "devops-subnet"}
variable "sa_name" {default = "sa-bastion-host"}
variable "sa_roles" {
    type =  list(string)
    default = ["roles/cloudsql.client"]
}
variable "sa_scopes" {
    type =  list(string)
    default = ["https://www.googleapis.com/auth/cloud-platform"]
}
variable "network_tags" {
    type =  list(string)
    default = ["allow-iap-ssh"]
}

variable "firewall_rules" {
  description = "List of firewall rules to create"
  type = list(object({
    name          = string
    description   = string
    port_list     = list(string)
    source_tags   = list(string)
    source_ranges = list(string)
    target_tags   = list(string)
  }))
  default = [
    {
      name          = "allow-iap-ssh"
      description   = "Allow SSH traffic from GCP Network"
      port_list     = ["22"]
      source_tags   = []
      source_ranges = ["35.235.240.0/20"]
      target_tags   = ["allow-iap-ssh"]
    }
  ]
}
