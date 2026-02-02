locals {
  project_id = var.project_id
  network = try(var.network.items[0], null)
  subnets = coalescelist(
    var.network != null ? [
      for subnet in try(local.network.subnets, []) : {
        name                  = subnet.name
        ip_cidr_range         = subnet.ip_cidr_range
        region                = try(subnet.region, null)
        allow_nat             = try(subnet.allow_nat, null)
        enable_private_access = try(subnet.enable_private_access, null)
        flow_logs_config      = try(subnet.flow_logs_config, null)
      }
    ] : var.subnets,
    [
      {
        name           = "public",
        ip_cidr_range  = cidrsubnet(local.valid_subnet_range, local.network_size_step, 1),
        region         = var.region,
        allow_nat      = true
      },
      {
        name          = "private",
        ip_cidr_range = cidrsubnet(local.valid_subnet_range, local.network_size_step, 2),
        allow_nat     = false
      }
    ]
  )

  # Allowed ranges for VPC Subnet
  # https://cloud.google.com/vpc/docs/vpc
  valid_subnet_range = try(var.valid_subnet_range, "192.168.0.0/16")
  network_size_step  = 20 - tonumber(split("/", local.valid_subnet_range)[1])


  common_resource_id = coalesce(var.common_resource_id, replace(local.project_id, "_", "-"))

  nat_external_ips = coalescelist(
    var.nat_external_ips,
    [{
      name        = var.custom_nat_ip_name == "" ? "${local.common_resource_id}-data-ext-nat-address-1" : var.custom_nat_ip_name,
      description = var.custom_nat_ip_desc == "" ? "Permanent NAT External IP for whitelisting, PLEASE DO NOT REMOVE IT" : var.custom_nat_ip_desc
      region      = var.region
    }]
  )

  subnets_to_allow_on_nat = var.nat_source_mode == "LIST_OF_SUBNETWORKS" ? [
    for subnet in local.subnets : subnet if coalesce(subnet.allow_nat, false)
  ] : []

  dont_create_nat = var.nat_source_mode == "LIST_OF_SUBNETWORKS" && length(local.subnets_to_allow_on_nat) == 0 && length(var.external_subnets_allows_nats) == 0

  distinct_nat_regions = toset(concat(
    [
      for subnet in local.subnets : coalesce(subnet.region, var.region)
      if coalesce(subnet.allow_nat, false)
    ],
    [
      for ip in local.nat_external_ips : ip.region
    ]
  ))

  allowed_natted_internal_subnets = {
    for subnet in local.subnets :
    subnet.name => google_compute_subnetwork.subnets[subnet.name]
    if coalesce(subnet.allow_nat, false)
  }

  allowed_natted_subnets = {
    for subnet in concat(
      values(local.allowed_natted_internal_subnets),
      var.external_subnets_allows_nats
    ) : subnet.self_link => subnet if subnet != null
  }

  psc_ip_range = coalesce(
    var.private_service_connect_cidr,
    cidrsubnet(var.valid_subnet_range, local.network_size_step, 15)
  )
}
