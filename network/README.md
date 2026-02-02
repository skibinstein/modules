## Network Module

This module creates:
* VPC
* Optionally - a deny firewall rule to 0.0.0.0/0
* Optionally - An allow firewall rule to vodafone github
* Router in selected region
* NAT gateway with manual IP addresses (1 by default)
* User-defined subnets (public and private subnet by default)
* Optionally - enables Service Networking API (if enable_private_service_connect is set to true, by default it is)
* Optionally - you can define which other subnetworks can be used for NAT configurations by including the `external_subnets_allows_nats` variable in your Terraform configuration which provides a list of subnetworks that you want to allow for NAT configurations. Please note that the specified subnetworks in this block must already exist.
### Examples
```tf
module "network" {
  source               = "git::https://github.com/VFGROUP-NSE-DNOSS/DNE-PE-NGDI-ORCHESTRATE/modules/network"
  project_name         = var.project_name
  region               = var.region
  common_resource_id   = local.common_resource_id
  deny_egress          = true
  allow_github_access = true
}
```

You are able to use this module to import an existing `VPC`, `Router`, `NAT` and `NAT IP` by setting the below `custom_names` variables:
```tf
module "network" {
  source               = "git::https://github.com/VFGROUP-NSE-DNOSS/DNE-PE-NGDI-ORCHESTRATE/modules/network"
  project_name         = var.project_name
  region               = var.region
  common_resource_id   = local.common_resource_id
  custom_vpc_name      = "test-vpc"
  custom_nat_name      = "test-nat"
  custom_nat_ip_name   = "test-nat-ip"
  custom_nat_ip_desc   = "Test NAT IP description"
  custom_router_name   = "test-router"
}
```
```yaml
  - source: "git::https://github.com/VFGROUP-NSE-DNOSS/DNE-PE-NGDI-ORCHESTRATE/modules/network"
    name: network
    project_name: ${var.project_id}
    region: europe-west1
    custom_nat_name: "test-nat"
    custom_nat_ip_name: "test-nat-ip"
    custom_nat_ip_desc: "Test NAT IP description"
    custom_router_name: "test-router"
```


### Private Service Connect

This module creates Private Service Connect connection by default (disable with variable: `enable_private_service_connect = false`).
It is a requirement to use multiple GCP services from your VPC, including CloudSQL and Cloud Build.
