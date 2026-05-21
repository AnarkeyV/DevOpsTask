variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
  default     = "rg-devopstask-demo"
}

variable "location" {
  description = "Azure region for the resources"
  type        = string
  default     = "southeastasia"
}

variable "acr_name" {
  description = "Name of the Azure Container Registry"
  type        = string
  default     = "devopstaskacr001"
}