<!-- BEGIN_TF_DOCS -->
# Complex Cloud Storage Bucket Module Usage Example

## Description

This is a complete example which demonstrates how to create a complex storage bucket.

## Usage

To provision this example, here is sample code:

### Enabling Version

```
module "gcs-bucket" {
  source     = "../../"
  project_id = var.project_id
  location   = var.region
  buckets = [{
    bucket_name                 = "a-unique-bucket-name"
    location                    = "gcp-region"
    storage_class               = "STANDARD"
    kms_key_name                = "kms-key"

    versioning_enabled          = true

  }]
} 
```

### Setting Labels

```
module "gcs-bucket" {
  source     = "../../"
  project_id = var.project_id
  location   = var.region
  buckets = [{
    bucket_name                 = "a-unique-bucket-name"
    location                    = "gcp-region"
    storage_class               = "STANDARD"
    kms_key_name                = "kms-key"

    labels                      = { label_1 = "label_1" }

  }]
} 
```

### Setting 'Accesses' to manage IAM Bindings

```
module "gcs-bucket" {
  source     = "../../"
  project_id = var.project_id
  location   = var.region
  buckets = [{
    bucket_name                 = "a-unique-bucket-name"
    location                    = "gcp-region"
    storage_class               = "STANDARD"
    kms_key_name                = "kms-key"

    accesses = [
      {
        role    = "roles/storage.admin"
        members = ["allAuthenticatedUsers"]
      },
      {
        role    = "roloes/storage.objectViewer"
        members = "individual_user@email.com"
      }
    ]
  }]
} 
```

### Setting Retention Policy

```
module "gcs-bucket" {
  source     = "../../"
  project_id = var.project_id
  location   = var.region
  buckets = [{
    bucket_name                 = "a-unique-bucket-name"
    location                    = "gcp-region"
    storage_class               = "STANDARD"
    kms_key_name                = "kms-key"
    
    retention_policy = {
      is_locked        = true
      retention_period = 30
    }
  }]
} 
```

### Setting Bucket for Logging

```
module "gcs-bucket" {
  source     = "../../"
  project_id = var.project_id
  location   = var.region
  buckets = [{
    bucket_name                 = "a-unique-bucket-name"
    location                    = "gcp-region"
    storage_class               = "STANDARD"
    uniform_bucket_level_access = true
    kms_key_name                = "kms-key"
    labels                      = { label_1 = "label_1" }
    versioning_enabled          = true

    logging = {
      log_bucket        = "log-bucket-name"
      log_object_prefix = "log-prefix"
    }
  }]
} 
```

### Setting Lifecycle Rules

```
module "gcs-bucket" {
  source     = "../../"
  project_id = var.project_id
  location   = var.region
  buckets = [{
    bucket_name                 = "a-unique-bucket-name"
    location                    = "gcp-region"
    storage_class               = "STANDARD"
    kms_key_name                = "kms-key"

    lifecycle_rule = {
      action = {
        type          = "SetStorageClass"
        storage_class = "ARCHIVE"
      }
      condition = {
        age                   = 90
        with_state            = "LIVE"
        created_before        = "2025-01-01"
        matches_storage_class = ["STANDARD", "NEARLINE"]
        num_newer_versions    = 0
      }
    }

  }]
} 
```

