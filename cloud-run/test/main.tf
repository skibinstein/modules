module "cloud-run" {
  source     = "../cloud-run"
  project_id = var.project_id
  region     = var.region
  name       = "hello-world-container"
  containers = {
    hello = { image = "us-docker.pkg.dev/cloudrun/container/hello" }
  }
  deletion_protection = false
}