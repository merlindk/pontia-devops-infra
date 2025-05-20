FROM python:3.10-slim

RUN mkdir -p /mlflow/mlruns /mlflow/artifacts && chmod -R 777 /mlflow
WORKDIR /mlflow

# Instalar dependencias
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

# Exponer puerto de MLflow
EXPOSE 5000

# Comando para iniciar MLflow server
CMD ["mlflow", "server", \
     "--host", "0.0.0.0", \
     "--port", "5000", \
     "--backend-store-uri", "sqlite:///mlflow.db", \
     "--default-artifact-root", "${MLFLOW_ARTIFACT_ROOT}", \
     "--workers", "1"]
