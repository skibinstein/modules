resource "google_compute_network" "vpc_network" {
  name                    = local.effective_custom_vpc_name == "" ? "${local.common_resource_id}-vpc" : local.effective_custom_vpc_name
  project                 = local.project_id
  auto_create_subnetworks = local.effective_auto_create_subnetworks
  routing_mode            = local.effective_routing_mode
  description             = local.effective_description
}

resource "google_compute_router" "router" {
  for_each = local.distinct_nat_regions
  project  = local.project_id
  name     = var.custom_router_name == "" ? "${local.common_resource_id}-router-${replace(each.value, ".", "-")}" : var.custom_router_name
  network  = google_compute_network.vpc_network.self_link
  region   = each.value
  bgp {
    asn = 64514
  }
}

resource "google_compute_address" "nat_external_ip" {
  project     = local.project_id
  for_each    = { for ip in local.nat_external_ips : ip.name => ip }
  name        = each.key
  description = each.value.description
  region      = each.value.region
}

resource "google_compute_router_nat" "router_nat" {
  for_each               = local.dont_create_nat ? toset([]) : local.distinct_nat_regions
  provider               = google-beta
  project                = local.project_id
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
  project                  = local.project_id
  name                     = "${local.common_resource_id}-subnet-${each.value.name}"
  network                  = google_compute_network.vpc_network.name
  region                   = coalesce(each.value.region, var.region)
  private_ip_google_access = coalesce(each.value.enable_private_access, true)
  ip_cidr_range            = each.value.ip_cidr_range

  log_config {
    aggregation_interval = try(each.value.flow_logs_config.aggregation_interval, "INTERVAL_30_SEC")
    flow_sampling        = try(each.value.flow_logs_config.flow_sampling, 1)
    metadata             = try(each.value.flow_logs_config.metadata, "INCLUDE_ALL_METADATA")
  }
}
