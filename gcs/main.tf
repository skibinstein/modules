locals {
  buckets = [
    for item in try(var.gcs.items, []) : {
      bucket_name                 = try(item.bucket_name, item.name)
      location                    = try(item.location, var.region)
      storage_class               = try(item.storage_class, var.bucket_default.storage_class)
      uniform_bucket_level_access = try(item.uniform_bucket_level_access, var.bucket_default.uniform_bucket_level_access)
      kms_key_name                = try(item.kms_key_name, var.bucket_default.kms_key_name)
      labels                      = try(item.labels, var.bucket_default.labels)
      versioning_enabled          = try(item.versioning_enabled, item.versioning, var.bucket_default.versioning_enabled)
      accesses = length(try(item.accesses, var.bucket_default.accesses)) > 0 ? item.accesses : [
        for role, members in try(item.iam, {}) : {
          role    = role
          members = members
        }
      ]
      retention_policy = try(item.retention_policy, var.bucket_default.retention_policy)
      logging          = try(item.logging, var.bucket_default.logging)
      lifecycle_rules  = try(item.lifecycle_rules, var.bucket_default.lifecycle_rules)
    }
  ]

  # VF LOCALS 
  # list of buckets
  all_buckets = [for i in local.buckets : merge(var.bucket_default, i)]
  # map of buckets
  bucket_map = { for bucket in local.all_buckets : bucket.bucket_name => bucket }

  # assigning roles 
  bucket_role_members = merge([for bucket in local.bucket_map :
    merge([for bucket_role in bucket.accesses : {
      for bucket_role_member in bucket_role.members :
      "${bucket.bucket_name}-${bucket_role.role}-${bucket_role_member}" =>
      {
        bucket_id = bucket.bucket_name,
        member    = bucket_role_member,
        role      = bucket_role.role
      }
    }]...)
  ]...)
}


resource "google_storage_bucket" "bucket" {
  project = var.project_id

  for_each                    = local.bucket_map
  name                        = each.value.bucket_name
  storage_class               = each.value.storage_class
  location                    = each.value.location
  uniform_bucket_level_access = each.value.uniform_bucket_level_access
  
  // TBD: Change according to policy.
  labels = each.value.labels

  versioning {
    enabled = each.value.versioning_enabled
  }

  dynamic "encryption" {
    for_each = each.value.kms_key_name != null ? [1] : []
    content {
      default_kms_key_name = each.value.kms_key_name
    }
  }

  # VF
  dynamic "lifecycle_rule" {
    for_each = (
      each.value.lifecycle_rules != null ? {
        for idx, rule in each.value.lifecycle_rules : idx => jsonencode(rule)
      } :
      each.value.lifecycle_rule != null ? {
        single = jsonencode(each.value.lifecycle_rule)
      } :
      {}
    )
    content {
      action {
        type          = lookup(jsondecode(lifecycle_rule.value).action, "type", null)
        storage_class = lookup(jsondecode(lifecycle_rule.value).action, "storage_class", null)
      }
      condition {
        age                   = lookup(jsondecode(lifecycle_rule.value).condition, "age", null)
        created_before        = lookup(jsondecode(lifecycle_rule.value).condition, "created_before", null)
        with_state            = lookup(jsondecode(lifecycle_rule.value).condition, "with_state", null)
        matches_storage_class = lookup(jsondecode(lifecycle_rule.value).condition, "matches_storage_class", null)
        num_newer_versions    = lookup(jsondecode(lifecycle_rule.value).condition, "num_newer_versions", null)
      }
    }
  }

  # VF 
  dynamic "retention_policy" {
    for_each = each.value.retention_policy != null ? tolist([each.value.retention_policy]) : []
    content {
      is_locked        = try(each.value.retention_policy.is_locked, false)
      retention_period = each.value.retention_policy.retention_period
    }
  }

  # logging 
  dynamic "logging" {
    for_each = each.value.logging != null ? tolist([each.value.logging]) : []
    content {
      log_bucket        = each.value.logging.log_bucket
      log_object_prefix = try(each.value.logging.log_object_prefix, null)
    }
  }

}

resource "google_storage_bucket_iam_member" "bucket_role_member" {
  for_each = local.bucket_role_members

  bucket = each.value.bucket_id
  role   = each.value.role
  member = each.value.member
}

