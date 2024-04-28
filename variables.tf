variable "region" {}

variable image {
  description = "Image name used for VSI."
  type        = string
  default     = "ibm-centos-7-6-minimal-amd64-2"
}
