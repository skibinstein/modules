variable "project_id" {
  type        = string
  description = "GCP Project ID."
}

variable "gcs" {
  description = "GCS config with items."
  type        = any
  default     = null
}

variable "region" {
  description = "GCP Region."
}

variable "bucket_default" {
  description = "A bucket object to be merged into."
  type = object({
    bucket_name                 = string
    location                    = string
    storage_class               = string
    uniform_bucket_level_access = bool
    kms_key_name                = string
    labels                      = map(string)
    versioning_enabled          = bool
    accesses = list(object({
      role    = string
      members = list(string)
    }))
    retention_policy = object({
      is_locked        = bool
      retention_period = number
    })
    logging = object({
      log_bucket        = string
      log_object_prefix = string
    })
    lifecycle_rules = list(object({
      action = map(string)
      condition = object({
        age                   = number
        with_state            = string
        created_before        = string
        matches_storage_class = list(string)
        num_newer_versions    = number
      })
    }))
  })
  default = {
    bucket_name                 = null
    location                    = null
    storage_class               = "STANDARD"
    uniform_bucket_level_access = true
    kms_key_name                = null
    labels                      = {}
    versioning_enabled          = false
    accesses                    = []
    retention_policy            = null
    logging                     = null
    lifecycle_rules             = []
  }
}