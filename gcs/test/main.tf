module "gcs-bucket" {
  source     = "../"
  project_id = var.project_id
  location   = var.region
  buckets = [{
    bucket_name  = "a-unique-bucket-name"
    location     = "gcp-region"
    kms_key_name = "kms-key"
  }]
} 