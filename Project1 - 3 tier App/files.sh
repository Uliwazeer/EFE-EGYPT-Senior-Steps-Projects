#!/bin/bash
# create_project_files.sh
# Usage: bash create_project_files.sh

PROJECT_DIR="project"

echo "Creating project structure..."

# إنشاء المجلدات
mkdir -p $PROJECT_DIR/backend
mkdir -p $PROJECT_DIR/nginx
mkdir -p $PROJECT_DIR/K8S

# ---------- BACKEND FILES ----------
touch $PROJECT_DIR/backend/Dockerfile
touch $PROJECT_DIR/backend/main.go
touch $PROJECT_DIR/backend/go.mod
touch $PROJECT_DIR/backend/go.sum
# ---------- NGINX FILES ----------
touch $PROJECT_DIR/nginx/Dockerfile
touch $PROJECT_DIR/nginx/nginx.conf
touch $PROJECT_DIR/nginx/generate-ssl.sh

# ---------- DOCKER-COMPOSE ----------
touch $PROJECT_DIR/docker-compose.yaml

# ---------- K8S FILES ----------
touch $PROJECT_DIR/K8S/backend_deployment.yaml
touch $PROJECT_DIR/K8S/backend_service.yaml
touch $PROJECT_DIR/K8S/database_deployment.yaml
touch $PROJECT_DIR/K8S/db-service.yaml
touch $PROJECT_DIR/K8S/db-secret.yaml
touch $PROJECT_DIR/K8S/db-data-pv.yaml
touch $PROJECT_DIR/K8S/db-data-pvc.yaml
touch $PROJECT_DIR/K8S/proxy_deployment.yaml
touch $PROJECT_DIR/K8S/proxy_nodeport.yaml

echo "All files and folders have been created successfully!"
