# Output public URL to access MLflow UI
output "mlflow_url" {
  value = "http://${azurerm_container_group.mlflow.fqdn}:5000"
}

# Output artifact storage connection string
output "mlflow_storage_connection_string" {
  value = azurerm_storage_account.mlflow.primary_connection_string
  sensitive = true
}

# Output MLflow artifact store URI
output "artifact_store_uri" {
  value = "wasbs://${azurerm_storage_container.artifacts.name}@${azurerm_storage_account.mlflow.name}.blob.core.windows.net/"
}
