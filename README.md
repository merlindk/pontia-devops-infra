
# 🧪 MLflow on Azure — Terraform Deployment Guide

This repository contains infrastructure-as-code for deploying an MLflow tracking server to Azure using:

- Azure Container Instances (ACI)
- Azure Blob Storage (or Azure File)
- Terraform
- A custom Docker image with MLflow and dependencies

---

## 🚀 Prerequisites

Before you begin, make sure you have:

- An [Azure account](https://portal.azure.com/)
- Azure CLI installed: [Install Guide](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- Terraform CLI installed: [Install Guide](https://learn.microsoft.com/en-us/azure/developer/terraform/get-started-windows-bash)

---

## 📦 1. Provision Azure Container Registry (ACR)

Follow this guide to create your ACR:
👉 [Create ACR - Azure Docs](https://learn.microsoft.com/en-us/azure/container-registry/container-registry-get-started-portal?tabs=azure-cli)

Example ACR name used in this project:

```
mlflowexample.azurecr.io
```

---

## 🔐 2. Authenticate Azure & Terraform

```bash
az login
az account set --subscription "<your-subscription-id>"
```

### Create a Service Principal for Terraform

```bash
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<subscriptionId>"
```

Record the output values:  
- `appId`
- `password`
- `tenant`

Set them as environment variables:

```bash
export ARM_CLIENT_ID="<appId>"
export ARM_CLIENT_SECRET="<password>"
export ARM_SUBSCRIPTION_ID="<subscriptionId>"
export ARM_TENANT_ID="<tenant>"
```

---

## 🛠 3. Build and Push Your MLflow Docker Image

### Enable ACR admin access and get credentials:

```bash
az acr update -n mlflowexample --admin-enabled true
az acr credential show --name mlflowexample
```

Copy the username and password and add them to your Terraform variables:

```hcl
image_registry_username = "<acr-username>"
image_registry_password = "<acr-password>"
```

### Build and push the image:

```bash
docker build -t mlflowexample.azurecr.io/mlflow:1.0 .
docker push mlflowexample.azurecr.io/mlflow:1.0
```

---

## 📐 4. Deploy with Terraform

```bash
terraform init
terraform plan -out "plan.tfplan"
terraform apply "plan.tfplan"
```

---

## 🔗 5. Set Azure Storage Connection

```bash
terraform output mlflow_storage_connection_string
```

Then set it in your environment:

```bash
export AZURE_STORAGE_CONNECTION_STRING="DefaultEndpointsProtocol=...;AccountName=...;AccountKey=...;EndpointSuffix=core.windows.net"
```

---

## 📡 Access MLflow UI

Access the MLflow UI using:

```bash
terraform output mlflow_url
```

---
