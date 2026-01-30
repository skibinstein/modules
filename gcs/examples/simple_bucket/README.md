<!-- BEGIN_TF_DOCS -->
# Simple Cloud Storage Bucket Module Usage Example

## Description

This is a complete example which demonstrates how to create a simple storage bucket.

## Usage

To provision this example, here is sample code:

```
module "gcs-bucket" {
  source     = "../../"
  project_id = var.project_id
  location   = var.region
  buckets = [{
    bucket_name  = "a-unique-bucket-name"
    location     = "gcp-region"
    kms_key_name = "kms-key"
  }]
} 
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_buckets"></a> [buckets](#input\_buckets) | Bucket to be created. | `any` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP Project ID. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->