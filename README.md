# DevOpsTask: Flask CI/CD Pipeline with Docker, Terraform, Kubernetes, Azure DevOps and Jenkins

This project demonstrates a complete CI/CD workflow for a Python Flask application. The application is containerized with Docker, stored in Azure Container Registry, deployed to a local Kubernetes cluster, and automated through Azure DevOps using a self-hosted MacBook agent. Jenkins is also integrated as a separate validation pipeline.

## Project Summary

The goal of this project is to move away from manual application updates and build a repeatable DevOps workflow.

When code is pushed to GitHub, Azure DevOps automatically:

1. Checks the Python application for syntax errors.
2. Installs dependencies.
3. Builds a Docker image.
4. Tags the image using the Azure DevOps Build ID.
5. Pushes the image to Azure Container Registry.
6. Updates the Kubernetes deployment.
7. Verifies that the new version rolls out successfully.

Jenkins is used separately to validate the same GitHub repository by creating a Python virtual environment, installing dependencies, and running a syntax check.

## Architecture

```text
GitHub Repository
├── Jenkins Validation Pipeline
│   ├── Checkout source code
│   ├── Create Python virtual environment
│   ├── Install dependencies
│   └── Run Python syntax check
│
└── Azure DevOps CI/CD Pipeline
    ├── Checkout source code
    ├── Run Python syntax check
    ├── Build Docker image
    ├── Push image to Azure Container Registry
    └── Deploy updated image to local Kubernetes
```

## Technologies Used

| Tool | Purpose |
|---|---|
| Python Flask | Web application framework |
| Gunicorn | Production-style Python application server |
| Docker | Containerizes the Flask application |
| Azure Container Registry | Private image registry for Docker images |
| Terraform | Provisions Azure infrastructure as code |
| Kubernetes | Runs and scales the containerized application |
| Docker Desktop Kubernetes | Local Kubernetes cluster on macOS |
| Azure DevOps | Main CI/CD automation platform |
| Azure DevOps self-hosted agent | Allows Azure DevOps to deploy to local Kubernetes |
| GitHub | Source code repository |
| Jenkins | Additional validation pipeline |

## Repository Structure

```text
DevOpsTask/
├── app.py
├── requirements.txt
├── Dockerfile
├── README.md
├── Jenkinsfile
├── azure-pipelines.yml
├── .gitignore
├── k8s/
│   ├── deployment.yaml
│   └── service.yaml
└── terraform/
    ├── main.tf
    ├── variables.tf
    └── outputs.tf
```

## Application Endpoints

| Endpoint | Purpose |
|---|---|
| `/` | Main Flask application page |
| `/health` | Health check endpoint |

Local Flask port used:

```text
5002
```

Port `5002` is used because macOS commonly reserves port `5000` for AirPlay, and port `5001` was already used by another project.

## Docker

The Flask application is packaged into a Docker image using the `Dockerfile`.

Manual local build:

```bash
docker build -t devopstask-flask:v1 .
```

Manual local run:

```bash
docker run -p 5002:5002 devopstask-flask:v1
```

Test in browser:

```text
http://localhost:5002
http://localhost:5002/health
```

## Terraform and Azure Container Registry

Terraform provisions:

- Azure Resource Group
- Azure Container Registry using the Basic SKU

Created Azure resources:

```text
Resource Group: rg-devopstask-demo
Azure Container Registry: devopstaskacr001
ACR Login Server: devopstaskacr001.azurecr.io
```

Useful Terraform commands:

```bash
cd terraform
terraform init
terraform validate
terraform plan
terraform apply
```

Important: Terraform state files are excluded from Git using `.gitignore` because they may contain sensitive information.

## Kubernetes

The application is deployed to a local Kubernetes cluster using Docker Desktop Kubernetes.

The Kubernetes deployment runs 3 replicas:

```yaml
replicas: 3
```

The deployment pulls the image from Azure Container Registry:

```text
devopstaskacr001.azurecr.io/devopstask-flask:<tag>
```

Useful Kubernetes commands:

```bash
kubectl get nodes
kubectl get deployments
kubectl get pods
kubectl get services
kubectl rollout status deployment/devopstask-flask
```

Because this is running on Docker Desktop Kubernetes on macOS, the application is accessed using port forwarding:

```bash
kubectl port-forward service/devopstask-flask-service 5002:5002
```

Then open:

```text
http://localhost:5002
http://localhost:5002/health
```

## Azure DevOps Pipeline

The Azure DevOps pipeline is defined in:

```text
azure-pipelines.yml
```

Pipeline flow:

```text
GitHub push
→ Azure DevOps pipeline triggered
→ Self-hosted MacBook agent runs the job
→ Python syntax check
→ Docker image build
→ Docker image tagged with Build ID
→ Docker image pushed to ACR
→ Kubernetes deployment updated
→ Rollout verified
```

The pipeline uses unique image tags based on the Azure DevOps Build ID. This avoids using `latest`, which is not ideal because it makes rollback, traceability, and troubleshooting harder.

Example image tag:

```text
devopstaskacr001.azurecr.io/devopstask-flask:10
```

## Jenkins Integration

Jenkins is used as a separate validation pipeline, not as the main deployment tool.

Jenkins pipeline purpose:

```text
Checkout code
Create virtual environment
Install dependencies
Run Python syntax check
```

Azure DevOps remains the main CI/CD tool because the project is Azure-focused.

## Failed Pipeline Demonstration

A deliberate syntax error was introduced into `app.py` and pushed to GitHub.

Result:

```text
Azure DevOps pipeline failed at the Python syntax check step.
Docker image was not built.
No image was pushed to ACR.
Kubernetes was not updated.
The previous working version continued running.
```

This demonstrates that CI/CD prevents broken code from being deployed.

## Key Learning Outcomes

Through this project, I practiced:

- Creating a Flask application.
- Containerizing an application with Docker.
- Creating a private registry using Azure Container Registry.
- Provisioning Azure resources with Terraform.
- Writing Kubernetes Deployment and Service manifests.
- Scaling an application to 3 replicas.
- Creating a CI/CD pipeline in Azure DevOps.
- Using a self-hosted agent to deploy to local Kubernetes.
- Using Jenkins as an additional validation tool.
- Demonstrating failed pipeline protection.

## Demo Commands

```bash
# Check Kubernetes resources
kubectl get deployments
kubectl get pods
kubectl get services

# Confirm current deployment image
kubectl describe deployment devopstask-flask | grep Image

# Access the app locally
kubectl port-forward service/devopstask-flask-service 5002:5002

# Check ACR image tags
az acr repository show-tags \
  --name devopstaskacr001 \
  --repository devopstask-flask \
  --output table
```

## Project Status

Completed:

- Flask app setup
- Docker containerization
- Terraform Azure infrastructure
- Azure Container Registry
- Kubernetes deployment
- 3 application replicas
- Azure DevOps CI/CD
- GitHub integration
- Self-hosted Azure DevOps agent
- Failed pipeline demo
- Jenkins validation pipeline

