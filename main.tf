# Create resource group
resource "azurerm_resource_group" "mlflow" {
  name     = var.resource_group_name
  location = var.location
}

# Create a storage account for MLflow artifacts
resource "azurerm_storage_account" "mlflow" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.mlflow.name
  location                 = azurerm_resource_group.mlflow.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Create a private blob container for storing MLflow artifacts
resource "azurerm_storage_container" "artifacts" {
  name                  = var.container_name
  storage_account_id = azurerm_storage_account.mlflow.id
  container_access_type = "private"
}

# Deploy MLflow using Azure Container Instance (ACI)
resource "azurerm_container_group" "mlflow" {
  name                = var.mlflow_container_name
  location            = azurerm_resource_group.mlflow.location
  resource_group_name = azurerm_resource_group.mlflow.name
  os_type             = "Linux"

  image_registry_credential {
    server   = "mlflowexample.azurecr.io"
    username = var.image_registry_username
    password = var.image_registry_password
  }

  container {
    name   = "mlflow"
    image  = var.mlflow_image
    cpu    = "1"
    memory = "2"

    ports {
      port     = 5000
      protocol = "TCP"
    }

    environment_variables = {
      AZURE_STORAGE_CONNECTION_STRING = azurerm_storage_account.mlflow.primary_connection_string
      MLFLOW_ARTIFACT_ROOT = "wasbs://${azurerm_storage_container.artifacts.name}@${azurerm_storage_account.mlflow.name}.blob.core.windows.net/"
    }

    commands = [
      "mlflow", "server",
      "--host", "0.0.0.0",
      "--port", "5000",
      "--backend-store-uri", "sqlite:///mlflow.db",
      "--default-artifact-root", "wasbs://${azurerm_storage_container.artifacts.name}@${azurerm_storage_account.mlflow.name}.blob.core.windows.net/"
    ]
  }

  ip_address_type = "Public"
  dns_name_label  = "mlflow-${random_integer.suffix.result}"
}

# Generate random suffix for DNS label uniqueness
resource "random_integer" "suffix" {
  min = 1000
  max = 9999
}