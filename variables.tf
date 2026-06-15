variable "product" {
}

variable "env" {}

variable "jenkins_AAD_objectId" {}

variable "product_group_name" {
  default = "DTS Property Tribunal"
}

variable "common_tags" {
  type = map(string)
}

variable "location" {
  default = "UK South"
}



variable "private_dns_subscription_id" {
  default = "1baf5470-1c3e-40d3-a6f7-74bfbce4b348"
}