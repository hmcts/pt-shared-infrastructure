variable "product" {}

variable "env" {}

variable "jenkins_AAD_objectId" {}

variable "product_group_name" {
  default = "DTS Residential Property Tribunal"
}

variable "common_tags" {
  type = map(string)
}

variable "location" {
  default = "UK South"
}
