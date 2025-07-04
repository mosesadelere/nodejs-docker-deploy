# nodejs-docker-deploy
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