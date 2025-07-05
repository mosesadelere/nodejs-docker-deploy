# nodejs-docker-deploy
Project: Automated Kubernetes Deployment Pipeline with Node.js App 
Overview 
This project demonstrates an end-to-end CI/CD pipeline for deploying a Dockerized Node.js application to a local Kubernetes cluster using modern DevOps tools. The pipeline includes: 
•	Infrastructure Provisioning : Automates the creation of a local Kubernetes cluster using Kind .
•	Helm Chart Management : Deploys the NGINX Ingress Controller via Helm .
•	CI/CD Automation : Uses GitHub Actions for continuous integration and deployment.
•	GitOps : Integrates Argo CD for declarative application management.
•	Dockerization : Builds and pushes Docker images to GitHub Container Registry.


Project Walkthrough
1. Clone the repo

    git clone https://github.com/mosesadelere/nodejs-docker-deploy.git
    cd nodejs-docker-deploy

2. Project structure

        ├── .github/workflows/       # GitHub Actions CI/CD pipelines
        ├── deploy.yml           # Deploys app to Kubernetes
        └── terraform.yml        # Sets up infra with Terraform
        ├── nodejs-deploy/           # Helm chart for deployment
        ├── Chart.yaml
        ├── templates/
        └── values.yaml
        ├── terraform/               # Terraform configs for Kind cluster
        ├── main.tf
        └── provider.tf
        ├── app/                     # Node.js application
        ├── Dockerfile
        ├── index.js
        └── package.json


3. Run Locally
    
    cd app
    npm install
    node index.js  # Runs on http://localhost:3000

4. Build & push Docker image to any registry of choice
    
    docker build -t your-dockerhub-username/nodejs-app:latest .
    docker push your-dockerhub-username/nodejs-app:latest

5. Deploy to Kubernetes

    # Install Kind (if not installed)
    curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
    chmod +x ./kind
    sudo mv ./kind /usr/local/bin/kind

    # Deploy Kind cluster & Helm chart
    cd terraform
    terraform init
    terraform apply -auto-approve

    # Apply the Helm chart
    helm install nodejs-app ./nodejs-deploy

6. Access the App

    kubectl port-forward svc/nodejs-app 3000:3000
    