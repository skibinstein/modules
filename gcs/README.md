<!-- BEGIN_TF_DOCS -->
# Cloud Storage Bucket Module

## Description

This module creates:

* One or more Google Cloud Storage buckets

## Examples

Here are examples of using this module:
* examples/simple_bucket
* examples/multiple_buckets
* examples/complex_bucket

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.14.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 7.15.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 7.16.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_storage_bucket.bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_default"></a> [bucket\_default](#input\_bucket\_default) | A bucket object to be merged into. | <pre>object({<br/>    bucket_name                 = string<br/>    location                    = string<br/>    storage_class               = string<br/>    uniform_bucket_level_access = bool<br/>    kms_key_name                = string<br/>    labels                      = map(string)<br/>    versioning_enabled          = bool<br/>    accesses = list(object({<br/>      role    = string<br/>      members = list(string)<br/>    }))<br/>    retention_policy = object({<br/>      is_locked        = bool<br/>      retention_period = number<br/>    })<br/>    logging = object({<br/>      log_bucket        = string<br/>      log_object_prefix = string<br/>    })<br/>    lifecycle_rule = object({<br/>      action = map(string)<br/>      condition = object({<br/>        age                   = number<br/>        with_state            = string<br/>        created_before        = string<br/>        matches_storage_class = list(string)<br/>        num_newer_versions    = number<br/>      })<br/>    })<br/>  })</pre> | <pre>{<br/>  "accesses": [],<br/>  "bucket_name": null,<br/>  "kms_key_name": null,<br/>  "labels": {},<br/>  "lifecycle_rule": null,<br/>  "location": null,<br/>  "logging": null,<br/>  "retention_policy": null,<br/>  "storage_class": "STANDARD",<br/>  "uniform_bucket_level_access": true,<br/>  "versioning_enabled": false<br/>}</pre> | no |
| <a name="input_buckets"></a> [buckets](#input\_buckets) | Map of Buckets to be Created. | `any` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP Project ID. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | GCP Region. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_names"></a> [bucket\_names](#output\_bucket\_names) | Names of all created buckets. |
<!-- END_TF_DOCS -->