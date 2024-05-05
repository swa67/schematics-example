# To use this workflow, you will need to complete the following setup steps.
#
# 1. Create a `main.tf` file in the root of this repository with the `remote` backend and one or more resources defined.
#   Example `main.tf`:
#     # The configuration for the `remote` backend.
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
         endpoint                    = "https://config.cloud-object-storage.cloud.ibm.com"
         access_key                  = data.ibm_resource_key.key.credentials["cos_hmac_keys.access_key_id"]
         secret_key                  = data.ibm_resource_key.key.credentials["cos_hmac_keys.secret_access_key"]
       }
     }

     # An example resource that does nothing.
     resource "null_resource" "example" {
       triggers = {
         value = "A example resource that does nothing!"
       }
     }

/*
variable "access_key" {
  description = "The prefix to append to your resources"
  type        = string
}


variable "secret_key" {
  description = "The prefix to append to your resources"
  type        = string
}
*/

data "ibm_resource_instance" "resource" {
  name = "icos-sh-tfstate"
  service = "cloud-object-storage"
}

data "ibm_resource_key" "key" {
  name                  = "sh-icos-credentials"
  resource_instance_id  = data.ibm_resource_instance.resource.id
}

output "access_key_id" {
  value = data.ibm_resource_key.key.credentials["cos_hmac_keys.access_key_id"]
}
output "secret_access_key" {
  value = data.ibm_resource_key.key.credentials["cos_hmac_keys.secret_access_key"]
}
