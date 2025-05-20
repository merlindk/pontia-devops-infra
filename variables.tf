# Location and naming variables
variable "location" {
  default = "eastus"
}

variable "resource_group_name" {
  default = "mlflow-rg"
}

variable "storage_account_name" {
  default = "mlflowstorage123456789"
}

variable "container_name" {
  default = "mlflow-artifacts"
}

variable "mlflow_container_name" {
  default = "mlflow-server"
}

variable "mlflow_image" {
  default = "mlflowexample.azurecr.io/mlflow:1.0"
}

variable "image_registry_username" {
  default = "mlflowexample"
  description = "image_registry username"
}

variable "image_registry_password" {
  description = "image_registry password or personal access token"
  sensitive   = true
}