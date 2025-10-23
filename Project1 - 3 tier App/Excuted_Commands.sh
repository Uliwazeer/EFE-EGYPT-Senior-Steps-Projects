#!/bin/bash
# ===============================================
# Executed Commands for 3-Tier Application Task
# Ali Wazeer
# ===============================================

# -----------------------------------------------
# Step 1: Check Docker images in Minikube environment
# ================================================
echo "Checking Docker images in Minikube..."
eval $(minikube docker-env)
docker images

# -----------------------------------------------
# Step 2: Build backend Go Docker image locally
# ================================================
echo "Building backend Docker image..."
docker build -t backend:latest ./backend

# -----------------------------------------------
# Step 3: Check Kubernetes pods status
# ================================================
echo "Listing all Kubernetes pods..."
kubectl get pods -o wide
kubectl get svc
kubectl get all
# -----------------------------------------------
# Step 4: Describe backend pod for troubleshooting
# ================================================
echo "Describing backend pod..."
kubectl describe pod -l app=backend

# -----------------------------------------------
# Step 5: Check Kubernetes services
# ================================================
echo "Listing all Kubernetes services..."
kubectl get svc

# -----------------------------------------------
# Step 6: Describe proxy service to verify ports and endpoints
# ================================================
echo "Describing proxy service..."
kubectl describe svc proxy-service

# -----------------------------------------------
# Step 7: Check logs of proxy pod
# ================================================
echo "Fetching logs from proxy pod..."
kubectl logs -l app=proxy

# -----------------------------------------------
# Step 8: Check backend secret to verify content
# ================================================
echo "Retrieving db-secret YAML..."
kubectl get secret db-secret -o yaml

# -----------------------------------------------
# Step 9: Execute commands inside backend pod
#          List mounted secrets directory
# ================================================
echo "Listing contents of /run/secrets in backend pod..."
BACKEND_POD=$(kubectl get pods -l app=backend -o jsonpath="{.items[0].metadata.name}")
kubectl exec -it $BACKEND_POD -- ls -l /run/secrets

# -----------------------------------------------
# Step 10: Port-forward backend service to test locally
# ================================================
echo "Port-forward backend service to localhost:8000..."
kubectl port-forward svc/backend-service 8000:8000 &

# -----------------------------------------------
# Step 11: Test backend API locally
# ================================================
echo "Testing backend API..."
curl http://localhost:8000/

# -----------------------------------------------
# Step 12: Test proxy HTTPS endpoint (ignore self-signed certificate)
# ================================================
echo "Testing proxy HTTPS endpoint..."
NODE_IP=$(minikube ip)
curl -k https://$NODE_IP:30443
curl -k https://$NODE_IP:30080

# -----------------------------------------------
# Step 13: Clean up port-forward process after test
# ================================================
echo "Cleaning up background port-forward process..."
kill $(jobs -p)

echo "All steps executed successfully."
