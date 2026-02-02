resource "google_compute_network" "vpc_network" {
  name                    = var.custom_vpc_name == "" ? "${local.common_resource_id}-vpc" : var.custom_vpc_name
  project                 = var.project_name
  auto_create_subnetworks = false
}

resource "google_compute_router" "router" {
  for_each = local.distinct_nat_regions
  project  = var.project_name
  name     = var.custom_router_name == "" ? "${local.common_resource_id}-router-${replace(each.value, ".", "-")}" : var.custom_router_name
  network  = google_compute_network.vpc_network.self_link
  region   = each.value
  bgp {
    asn = 64514
  }
}

resource "google_compute_address" "nat_external_ip" {
  project     = var.project_name
  for_each    = { for ip in local.nat_external_ips : ip.name => ip }
  name        = each.key
  description = each.value.description
  region      = each.value.region
}

resource "google_compute_router_nat" "router_nat" {
  for_each               = local.dont_create_nat ? toset([]) : local.distinct_nat_regions
  provider               = google-beta
  project                = var.project_name
  region                 = each.value
  name                   = var.custom_nat_name == "" ? "${local.common_resource_id}-nat-gateway-${replace(each.value, ".", "-")}" : var.custom_nat_name
  router                 = google_compute_router.router[each.key].name
  min_ports_per_vm       = var.min_ports_per_vm
  nat_ip_allocate_option = "MANUAL_ONLY"
  nat_ips = [
    for ip in local.nat_external_ips :
    google_compute_address.nat_external_ip[ip.name].self_link
    if ip.region == each.value
  ]

  source_subnetwork_ip_ranges_to_nat = var.nat_source_mode

  dynamic "subnetwork" {
    for_each = local.allowed_natted_subnets
    content {
      name                    = subnetwork.value.self_link
      source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
    }
  }

  log_config {
    enable = true
    filter = var.nat_log_filter
  }
}

resource "google_compute_subnetwork" "subnets" {
  for_each                 = { for subnet in local.subnets : subnet.name => subnet }
  project                  = var.project_name
  name                     = "${local.common_resource_id}-subnet-${each.value.name}"
  network                  = google_compute_network.vpc_network.name
  region                   = coalesce(each.value.region, var.region)
  private_ip_google_access = true
  ip_cidr_range            = each.value.cidr

  log_config {
    aggregation_interval = "INTERVAL_30_SEC"
    flow_sampling        = 1
    metadata             = "INCLUDE_ALL_METADATA"
  }
}
