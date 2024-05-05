# 1. Create a `main.tf` file in the root of this repository with the `remote` backend and one or more resources defined.
#   Example `main.tf`:
     # The configuration for the `remote` backend.
     terraform {
/*
       backend "remote" {
         # The name of your Terraform Cloud organization.
         organization = "example-organization"

         # The name of the Terraform Cloud workspace to store Terraform state files in.
         workspaces {
           name = "example-workspace"
         }
       }
*/
       backend "s3" {
         bucket                      = "sh-tfstate"
         key                         = "global.tfstate"
         region                      = "us-south"
         skip_region_validation      = true
         skip_credentials_validation = true
         skip_metadata_api_check     = true
         endpoints.s3                    = "https://config.cloud-object-storage.cloud.ibm.com"
       }

     }

     # An example resource that does nothing.
     resource "null_resource" "example" {
       triggers = {
         value = "A example resource that does nothing!"
       }
     }
