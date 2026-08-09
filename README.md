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
    for authentication http://localhost:3000/secret

4. Build & push Docker image to any registry of choice
    
    docker build -t your-dockerhub-username/nodejs-app:latest .
    docker run -d --name nodeproject -p 3000:3000 --env-file .env your-dockerhub-username/nodejs-app:latest
    docker login
    docker push your-dockerhub-username/nodejs-app:latest

5. Kubernetes Deployment

    # Install Kind (if not installed)
    curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
    chmod +x ./kind
    sudo mv ./kind /usr/local/bin/kind

    # Deploy Kind cluster & Helm chart
    cd manifest
    terraform init
    terraform apply -auto-approve

    The above commands create:
    A Kind cluster named "demo-git-action" as defined in `main.tf`
    Required node configurations for running ingress controller

    # Verify the Cluster
    kubectl get nodes # this checks the cluster nodes
    kubectl cluster-info

    # Helm Deployment
    Deploy the NGINX Ingress controller and Node.js application using Helm.

    helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
    helm repo update

    helm install ingress-nginx ingress-nginx/ingress-nginx \
    --namespace ingress-nginx \
    --create-namespace


    # Apply the Helm chart
    helm install nodejs-app ./nodejs-deploy

    # Verify Deployment
    helm list /* check Helm release */

    /* Check Kubernetes resources */
    kubectl get pods
    kubectl get svc
    kubectl get ingress

6. Access the App
    1. Port forwarding
    # Forward the service port to your local machine
    kubectl port-forward svc/nodejs-app 3000:3000
     Then open: http://localhost:3000

    2. Using Ingress controller
    If using the NGINX Ingress controller, get the ingress address:
    kubectl get ingress
    
    For Kind clusters, you may need to forward the ingress controller port:
    kubectl port-forward -n ingress-nginx svc/ingress-nginx-controller 8080:80

    Then access via: http://localhost:8080
    
7.  GitOps with ArgoCD

    For declarative continuous delivery, integrate ArgoCD:

    # Install ArgoCD

    kubectl create namespace argocd
    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

    # Access ArgoCD UI

    kubectl port-forward svc/argocd-server -n argocd 8080:443
    Then access via: https://localhost:8080
    Get the Password:

    kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

    # Create an Application

    argocd app create nodejs-app \
    --repo https://github.com/mosesadelere/nodejs-docker-deploy.git \
    --path nodejs-deploy \
    --dest-server https://kubernetes.default.svc \
    --dest-namespace default \
    --sync-policy automated

    # Synchonization and Monitor

    argocd app sync nodejs-app
    argocd app get nodejs-app