<!-- BEGIN_TF_DOCS -->
# Multiple Cloud Storage Buckets Module Usage Example

## Description

This is a complete example which demonstrates how to create multiple storage buckets.

## Usage

To provision this example, here is sample code:

```
module "gcs-buckets" {
  source     = "../../"
  project_id = var.project_id
  location   = var.region
  buckets = [{
    bucket_name  = "a-unique-bucket-name"
    location     = "gcp-region"
    kms_key_name = "kms-key"
    },
    {
      bucket_name  = "a-unique-bucket-name-2"
      location     = "gcp-region"
      kms_key_name = "kms-key"
    },
    {
      bucket_name  = "a-unique-bucket-name-3"
      location     = "gcp-region"
      kms_key_name = "kms-key"
  }]
}
```
