resource "google_compute_firewall" "rules" {
  for_each    = { for rule in var.firewall_rules : rule.name => rule }
  project     = var.project_id
  name        = each.value.name
  network     = var.vpc_name
  description = each.value.description

  allow {
    protocol = "tcp"
    ports    = each.value.port_list
  }

  source_tags = each.value.source_tags
  source_ranges = each.value.source_ranges
  target_tags = each.value.target_tags
}
