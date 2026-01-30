<!-- BEGIN_TF_DOCS -->
# Cloud Run Module

## Description 

Creates Cloud Run Services and Jobs.

## Examples

Examples of using this module are in the /examples folder. 

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.14.0, < 2.0.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 7.16.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | ~> 7.16.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 7.16.0 |
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | ~> 7.16.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google-beta_google_cloud_run_v2_job.job](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_cloud_run_v2_job) | resource |
| [google-beta_google_cloud_run_v2_job.job_unmanaged](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_cloud_run_v2_job) | resource |
| [google-beta_google_cloud_run_v2_service.service](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_cloud_run_v2_service) | resource |
| [google-beta_google_cloud_run_v2_service.service_unmanaged](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_cloud_run_v2_service) | resource |
| [google-beta_google_cloud_run_v2_worker_pool.default_managed](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_cloud_run_v2_worker_pool) | resource |
| [google-beta_google_cloud_run_v2_worker_pool.default_unmanaged](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_cloud_run_v2_worker_pool) | resource |
| [google_cloud_run_v2_job_iam_binding.binding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_v2_job_iam_binding) | resource |
| [google_cloud_run_v2_service_iam_binding.binding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_v2_service_iam_binding) | resource |
| [google_cloud_run_v2_worker_pool_iam_binding.binding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_v2_worker_pool_iam_binding) | resource |
| [google_eventarc_trigger.audit_log_triggers](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/eventarc_trigger) | resource |
| [google_eventarc_trigger.pubsub_triggers](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/eventarc_trigger) | resource |
| [google_eventarc_trigger.storage_triggers](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/eventarc_trigger) | resource |
| [google_iap_web_cloud_run_service_iam_binding.binding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iap_web_cloud_run_service_iam_binding) | resource |
| [google_iap_web_cloud_run_service_iam_member.member](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iap_web_cloud_run_service_iam_member) | resource |
| [google_project_iam_member.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_service_account.service_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_tags_location_tag_binding.binding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/tags_location_tag_binding) | resource |
| [google_vpc_access_connector.connector](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/vpc_access_connector) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_containers"></a> [containers](#input\_containers) | Containers in name => attributes format. | <pre>map(object({<br/>    image      = string<br/>    depends_on = optional(list(string))<br/>    command    = optional(list(string))<br/>    args       = optional(list(string))<br/>    env        = optional(map(string))<br/>    env_from_key = optional(map(object({<br/>      secret  = string<br/>      version = string<br/>    })))<br/>    liveness_probe = optional(object({<br/>      grpc = optional(object({<br/>        port    = optional(number)<br/>        service = optional(string)<br/>      }))<br/>      http_get = optional(object({<br/>        http_headers = optional(map(string))<br/>        path         = optional(string)<br/>        port         = optional(number)<br/>      }))<br/>      failure_threshold     = optional(number)<br/>      initial_delay_seconds = optional(number)<br/>      period_seconds        = optional(number)<br/>      timeout_seconds       = optional(number)<br/>    }))<br/>    ports = optional(map(object({<br/>      container_port = optional(number)<br/>      name           = optional(string)<br/>    })))<br/>    resources = optional(object({<br/>      limits            = optional(map(string))<br/>      cpu_idle          = optional(bool)<br/>      startup_cpu_boost = optional(bool)<br/>    }))<br/>    startup_probe = optional(object({<br/>      grpc = optional(object({<br/>        port    = optional(number)<br/>        service = optional(string)<br/>      }))<br/>      http_get = optional(object({<br/>        http_headers = optional(map(string))<br/>        path         = optional(string)<br/>        port         = optional(number)<br/>      }))<br/>      tcp_socket = optional(object({<br/>        port = optional(number)<br/>      }))<br/>      failure_threshold     = optional(number)<br/>      initial_delay_seconds = optional(number)<br/>      period_seconds        = optional(number)<br/>      timeout_seconds       = optional(number)<br/>    }))<br/>    volume_mounts = optional(map(string))<br/>  }))</pre> | `{}` | no |
| <a name="input_context"></a> [context](#input\_context) | Context-specific interpolations. | <pre>object({<br/>    condition_vars = optional(map(map(string)), {}) # not needed here?<br/>    cidr_ranges    = optional(map(string), {})<br/>    custom_roles   = optional(map(string), {})<br/>    iam_principals = optional(map(string), {})<br/>    kms_keys       = optional(map(string), {})<br/>    locations      = optional(map(string), {})<br/>    networks       = optional(map(string), {})<br/>    project_ids    = optional(map(string), {})<br/>    subnets        = optional(map(string), {})<br/>    tag_values     = optional(map(string), {})<br/>  })</pre> | `{}` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Deletion protection setting for this Cloud Run service. | `string` | `null` | no |
| <a name="input_encryption_key"></a> [encryption\_key](#input\_encryption\_key) | The full resource name of the Cloud KMS CryptoKey. | `string` | `null` | no |
| <a name="input_iam"></a> [iam](#input\_iam) | IAM bindings for Cloud Run service in {ROLE => [MEMBERS]} format. | `map(list(string))` | `{}` | no |
| <a name="input_job_config"></a> [job\_config](#input\_job\_config) | Cloud Run Job specific configuration. | <pre>object({<br/>    max_retries = optional(number)<br/>    task_count  = optional(number)<br/>    timeout     = optional(string)<br/>  })</pre> | `{}` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Resource labels. | `map(string)` | `{}` | no |
| <a name="input_launch_stage"></a> [launch\_stage](#input\_launch\_stage) | The launch stage as defined by Google Cloud Platform Launch Stages. | `string` | `null` | no |
| <a name="input_managed_revision"></a> [managed\_revision](#input\_managed\_revision) | Whether the Terraform module should control the deployment of revisions. | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | Name used for Cloud Run service. | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project id used for all resources. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region used for all resources. | `string` | n/a | yes |
| <a name="input_revision"></a> [revision](#input\_revision) | Revision template configurations. | <pre>object({<br/>    gpu_zonal_redundancy_disabled = optional(bool)<br/>    labels                        = optional(map(string))<br/>    name                          = optional(string)<br/>    node_selector = optional(object({<br/>      accelerator = string<br/>    }))<br/>    vpc_access = optional(object({<br/>      connector = optional(string)<br/>      egress    = optional(string)<br/>      network   = optional(string)<br/>      subnet    = optional(string)<br/>      tags      = optional(list(string))<br/>    }), {})<br/>    timeout = optional(string)<br/>    # deprecated fields<br/>    gen2_execution_environment = optional(any) # DEPRECATED<br/>    job                        = optional(any) # DEPRECATED<br/>    max_concurrency            = optional(any) # DEPRECATED<br/>    max_instance_count         = optional(any) # DEPRECATED<br/>    min_instance_count         = optional(any) # DEPRECATED<br/>  })</pre> | `{}` | no |
| <a name="input_service_account_config"></a> [service\_account\_config](#input\_service\_account\_config) | Service account configurations. | <pre>object({<br/>    create       = optional(bool, true)<br/>    display_name = optional(string)<br/>    email        = optional(string)<br/>    name         = optional(string)<br/>    roles = optional(list(string), [<br/>      "roles/logging.logWriter",<br/>      "roles/monitoring.metricWriter"<br/>    ])<br/>  })</pre> | `{}` | no |
| <a name="input_service_config"></a> [service\_config](#input\_service\_config) | Cloud Run service specific configuration options. | <pre>object({<br/>    custom_audiences = optional(list(string), null)<br/>    eventarc_triggers = optional(<br/>      object({<br/>        audit_log = optional(map(object({<br/>          method  = string<br/>          service = string<br/>        })))<br/>        pubsub = optional(map(string))<br/>        storage = optional(map(object({<br/>          bucket = string<br/>          path   = optional(string)<br/>        })))<br/>        service_account_email = optional(string)<br/>    }), {})<br/>    gen2_execution_environment = optional(bool, false)<br/>    iap_config = optional(object({<br/>      iam          = optional(list(string), [])<br/>      iam_additive = optional(list(string), [])<br/>    }), null)<br/>    ingress              = optional(string, null)<br/>    invoker_iam_disabled = optional(bool, false)<br/>    max_concurrency      = optional(number)<br/>    scaling = optional(object({<br/>      max_instance_count = optional(number)<br/>      min_instance_count = optional(number)<br/>    }))<br/>    timeout = optional(string)<br/>  })</pre> | `{}` | no |
| <a name="input_tag_bindings"></a> [tag\_bindings](#input\_tag\_bindings) | Tag bindings for this service, in key => tag value id format. | `map(string)` | `{}` | no |
| <a name="input_type"></a> [type](#input\_type) | Type of Cloud Run resource to deploy: JOB, SERVICE or WORKERPOOL. | `string` | `"SERVICE"` | no |
| <a name="input_volumes"></a> [volumes](#input\_volumes) | Named volumes in containers in name => attributes format. | <pre>map(object({<br/>    secret = optional(object({<br/>      name         = string<br/>      default_mode = optional(string)<br/>      path         = optional(string)<br/>      version      = optional(string)<br/>      mode         = optional(string)<br/>    }))<br/>    cloud_sql_instances = optional(list(string))<br/>    empty_dir_size      = optional(string)<br/>    gcs = optional(object({<br/>      # needs revision.gen2_execution_environment<br/>      bucket       = string<br/>      is_read_only = optional(bool)<br/>    }))<br/>    nfs = optional(object({<br/>      server       = string<br/>      path         = optional(string)<br/>      is_read_only = optional(bool)<br/>    }))<br/>  }))</pre> | `{}` | no |
| <a name="input_vpc_connector_create"></a> [vpc\_connector\_create](#input\_vpc\_connector\_create) | VPC connector network configuration. Must be provided if new VPC connector is being created. | <pre>object({<br/>    ip_cidr_range = optional(string)<br/>    machine_type  = optional(string)<br/>    name          = optional(string)<br/>    network       = optional(string)<br/>    instances = optional(object({<br/>      max = optional(number)<br/>      min = optional(number)<br/>      }), {}<br/>    )<br/>    throughput = optional(object({<br/>      max = optional(number)<br/>      min = optional(number)<br/>      }), {}<br/>    )<br/>    subnet = optional(object({<br/>      name       = optional(string)<br/>      project_id = optional(string)<br/>    }), {})<br/>  })</pre> | `null` | no |
| <a name="input_workerpool_config"></a> [workerpool\_config](#input\_workerpool\_config) | Cloud Run Worker Pool specific configuration. | <pre>object({<br/>    scaling = optional(object({<br/>      manual_instance_count = optional(number)<br/>      max_instance_count    = optional(number)<br/>      min_instance_count    = optional(number)<br/>      mode                  = optional(string)<br/>    }))<br/>  })</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | Fully qualified job or service id. |
| <a name="output_invoke_command"></a> [invoke\_command](#output\_invoke\_command) | Command to invoke Cloud Run Service / submit job. |
| <a name="output_job"></a> [job](#output\_job) | Cloud Run Job. |
| <a name="output_resource"></a> [resource](#output\_resource) | Cloud Run resource (job, service or worker\_pool). |
| <a name="output_resource_name"></a> [resource\_name](#output\_resource\_name) | Cloud Run resource (job, service or workerpool)  service name. |
| <a name="output_service"></a> [service](#output\_service) | Cloud Run Service. |
| <a name="output_service_account"></a> [service\_account](#output\_service\_account) | Service account resource. |
| <a name="output_service_account_email"></a> [service\_account\_email](#output\_service\_account\_email) | Service account email. |
| <a name="output_service_account_iam_email"></a> [service\_account\_iam\_email](#output\_service\_account\_iam\_email) | Service account email. |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | Cloud Run service name. |
| <a name="output_service_uri"></a> [service\_uri](#output\_service\_uri) | Main URI in which the service is serving traffic. |
| <a name="output_vpc_connector"></a> [vpc\_connector](#output\_vpc\_connector) | VPC connector resource if created. |
<!-- END_TF_DOCS -->