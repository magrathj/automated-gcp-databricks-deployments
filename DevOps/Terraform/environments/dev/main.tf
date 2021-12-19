terraform {
    required_providers {
        databricks = {
            source = "databrickslabs/databricks"
            version = "0.3.7"
        }
    }
}

provider "google" {
    project = var.google_project
    region = "us-central1"
    zone = "us-central1-c"
}

provider "databricks" {
    alias = "accounts"
    host = "https://accounts.gcp.databricks.com"
    google_service_account = var.databricks_google_service_account
}

data "google_client_openid_userinfo" "me" {

}

data "google_client_config" "current" {

}

resource "databricks_mws_workspaces" "this" {
    provider = databricks.accounts
    account_id = var.databricks_account_id
    workspace_name = "dev"
    location = data.google_client_config.current.region
    cloud_resource_bucket {
        gcp {
            project_id = data.google_client_config.current.project
        }
    }
}
