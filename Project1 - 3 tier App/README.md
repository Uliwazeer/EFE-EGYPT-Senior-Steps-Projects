# Three-Tier Blog API Application — Backend | Database | Proxy

Welcome to the **Three-Tier Blog API** project! This repository demonstrates a complete **3-tier web application** using Go, MySQL, and Nginx, deployed both via Docker Compose for local testing and Kubernetes for production-like orchestration.  

---

## Project Overview

This project implements a simple **blog API system** with three main components:

1. **Backend API (Go)**  
   - Serves REST responses returning a list of blog titles.  
   - Built using a **multi-stage Dockerfile**:
     - **Stage 1:** Compile Go binary.
     - **Stage 2:** Run the optimized binary on a minimal image (Alpine).

2. **Database (MySQL)**  
   - Stores blog titles.  
   - Credentials are handled securely:
     - `db-password.txt` for local Docker Compose setup.  
     - `db-secret.yaml` for Kubernetes deployments.  
   - Persistent storage via:
     - `db-data-pv.yaml` (Persistent Volume)  
     - `db-data-pvc.yaml` (Persistent Volume Claim)

3. **Proxy (Nginx)**  
   - Acts as a reverse proxy to the backend API.  
   - Exposes the application over **HTTPS** using a self-signed certificate (generated with `generate-ssl.sh`).  

---

## Features

- Fully functional 3-tier architecture accessible via **HTTPS**.  
- Docker images for all components to simplify deployment.  
- Kubernetes manifests for automated deployment and orchestration:  
  - Backend: `backend_deployment.yaml`, `backend_service.yaml`  
  - Database: `database_deployment.yaml`, `db-service.yaml`, `db-secret.yaml`  
  - Proxy: `proxy_deployment.yaml`, `proxy_nodeport.yaml`  
  - Persistent Storage: `db-data-pv.yaml`, `db-data-pvc.yaml`  

---

## Prerequisites

- **Docker** & **Docker Compose** installed for local testing.  
- **Minikube** or a Kubernetes cluster for full deployment.  
- **kubectl** CLI configured for the cluster.  
- Go installed locally if you want to run the backend outside Docker.  

---

## Project Structure

```

.
├── backend/
│   ├── Dockerfile
│   ├── go.mod
│   ├── go.sum
│   └── main.go
├── db-data-pv.yaml
├── db-data-pvc.yaml
├── db-secret.yaml
├── backend_deployment.yaml
├── backend_service.yaml
├── database_deployment.yaml
├── db-service.yaml
├── proxy_deployment.yaml
├── proxy_nodeport.yaml
├── generate-ssl.sh
├── docker-compose.yaml
└── executed_commands.sh

````

---

## How to Run the Project

You can run the project either **locally using Docker Compose** or on **Kubernetes**.  

### 1. Local Testing with Docker Compose

```bash
# Start all components locally
docker-compose up -d

# Check logs for backend
docker-compose logs -f backend

# Access backend API
curl http://localhost:8000/

# Access through Nginx proxy with HTTPS
curl -k https://localhost:30443
````

---

### 2. Full Deployment on Kubernetes

1. **Configure Docker to use Minikube environment**

   ```bash
   eval $(minikube docker-env)
   ```

2. **Build backend Docker image locally**

   ```bash
   docker build -t backend:latest ./backend
   ```

3. **Deploy all components using kubectl**

   ```bash
   kubectl apply -f db-data-pv.yaml
   kubectl apply -f db-data-pvc.yaml
   kubectl apply -f db-secret.yaml
   kubectl apply -f database_deployment.yaml
   kubectl apply -f db-service.yaml
   kubectl apply -f backend_deployment.yaml
   kubectl apply -f backend_service.yaml
   kubectl apply -f proxy_deployment.yaml
   kubectl apply -f proxy_nodeport.yaml
   ```

4. **Check the status of pods and services**

   ```bash
   kubectl get pods
   kubectl get svc
   ```

5. **Test backend API via proxy**

   ```bash
   NODE_IP=$(minikube ip)
   curl -k https://$NODE_IP:30443
   ```

---

### 3. Automating All Steps

We created a script to automate all commands for building, deploying, and testing:

```bash
./executed_commands.sh
```

* This script covers:

  * Building Docker images
  * Deploying Kubernetes manifests
  * Inspecting pods, secrets, services
  * Port-forwarding and testing endpoints

---

## Common Issues & Troubleshooting

* **Backend CrashLoopBackOff** → Usually caused by missing `db-password` secret or wrong volume mount.
* **502 Bad Gateway on Proxy** → Ensure backend pods are running and accessible; check service selectors.
* **Self-signed certificate warning** → Use `curl -k` to ignore SSL verification for testing.

---

## Expected Deliverables

* Fully functional **3-tier application** accessible via HTTPS.
* Docker images for backend, database, and proxy.
* Kubernetes manifests for automated deployment:

  * `backend_deployment.yaml`, `backend_service.yaml`
  * `database_deployment.yaml`, `db-service.yaml`, `db-secret.yaml`
  * `proxy_deployment.yaml`, `proxy_nodeport.yaml`
  * `db-data-pv.yaml`, `db-data-pvc.yaml`

---

## Author

**Ali Wazeer** — DevOps / Kubernetes enthusiast
[LinkedIn](https://www.linkedin.com/in/aliwazeer/)

<img width="1366" height="713" alt="Screenshot (515)" src="https://github.com/user-attachments/assets/8133716e-5453-4ce4-b6c6-e4c55b1661ab" />
<img width="1366" height="713" alt="Screenshot (514)" src="https://github.com/user-attachments/assets/044d5f0c-2101-492c-a9b2-4ff409dd4cec" />
<img width="1366" height="713" alt="Screenshot (513)" src="https://github.com/user-attachments/assets/78a789a6-0a25-4ec6-927f-d9f19b3c5d65" />
<img width="1366" height="717" alt="Screenshot (512)" src="https://github.com/user-attachments/assets/9a2d4132-3a05-4f5c-b715-62d7f7c71886" />
<img width="1366" height="172" alt="Screenshot (511)" src="https://github.com/user-attachments/assets/5a11fb01-5485-440b-a8b2-2666aa50c28c" />
<img width="1366" height="550" alt="Screenshot (510)" src="https://github.com/user-attachments/assets/def87f48-ac1f-4b9a-adbd-fc471e94b1a4" />
<img width="1366" height="708" alt="Screenshot (509)" src="https://github.com/user-attachments/assets/e39e21ef-1080-4d9d-b80b-6c510030f69a" />
<img width="1366" height="407" alt="Screenshot (508)" src="https://github.com/user-attachments/assets/e73febe9-6bca-40d8-bea6-9955f33a0e52" />
<img width="1366" height="713" alt="Screenshot (507)" src="https://github.com/user-attachments/assets/9a88982a-8096-4057-b529-e2f38044c02e" />
<img width="1366" height="516" alt="Screenshot (506)" src="https://github.com/user-attachments/assets/ef921f0f-6deb-46b4-8ff9-1afe65a72af8" />
![WhatsApp Image 2025-10-23 at 20 02 45_1c2a3a52](https://github.com/user-attachments/assets/bfd02945-7771-4f2f-82ff-9222c1e27044)
<img width="1366" height="136" alt="Screenshot (516)" src="https://github.com/user-attachments/assets/b6989fa2-dfc2-4ed6-800b-0446fdc3721e" />


