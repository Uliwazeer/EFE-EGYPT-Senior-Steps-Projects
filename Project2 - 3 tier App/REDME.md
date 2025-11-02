# 🚀 Jenkins Project Scenario – 3-Tier Application CI/CD on Kubernetes
![download](https://github.com/user-attachments/assets/9ceb8e9e-dde2-4b1d-80a0-e4d669a45812)

## 📘 Overview
This project demonstrates a **Complete CI/CD Pipeline for a 3-Tier Application** (Backend, Proxy, Database) using **Jenkins running as a Pod on Kubernetes**.  
It is designed to showcase **cloud-native DevOps automation**, where every pipeline stage runs inside dynamically provisioned Jenkins agent Pods.

---

## 📂 Application Source Code
**Repository:** [project2](https://github.com/Uliwazeer/project2)

The source repository includes three main components:

| Component | Description |
|------------|-------------|
| **backend/** | Contains the core application logic and REST API code. |
| **proxy/** | Includes NGINX configuration for routing and reverse proxying. |
| **database/** | Holds initialization scripts, schema setup, and database seed data. |

---

## 🧩 Core Concept: Jenkins as a Pod
Jenkins is deployed **as a Pod** within the Kubernetes cluster under the **`jenkins` namespace**.  
For each pipeline stage, Jenkins spawns a **temporary Agent Pod** to execute tasks such as:

- Building Docker images  
- Running tests  
- Deploying workloads  

Once a stage completes, its corresponding agent Pod is **automatically deleted**, ensuring an **ephemeral and resource-efficient CI/CD process**.

---

## 🏗️ Updated Architecture Diagram
> *(Insert updated architecture diagram here once available — e.g., using a markdown image link)*

```

Client
│
▼
[ NGINX Proxy (Frontend Layer) ]
│
▼
[ Backend (API Layer) ]
│
▼
[ Database (Data Layer) ]

```

**CI/CD Pipeline Control Plane:**  
All pipeline tasks are managed by **Jenkins running inside Kubernetes**, with images stored in a **Docker registry** and deployments automated via **kubectl** or **Helm**.

---

## 🔁 CI/CD Pipeline Flow

| Stage | Description |
|--------|--------------|
| **1️⃣ Source Stage** | Jenkins pulls the latest application source code from the GitHub repository. |
| **2️⃣ Build Stage** | Jenkins builds Docker images for **backend**, **proxy**, and **database**, tagging each image with the build number (`${BUILD_NUMBER}`). |
| **3️⃣ Push Stage** | The newly built images are pushed to a container registry (e.g., DockerHub). |
| **4️⃣ Deploy Stage** | Jenkins deploys the updated images to the Kubernetes cluster (namespace: `dev`) using **Helm charts** or **kubectl** manifests. |
| **5️⃣ Smoke Test** | Jenkins validates deployment health by checking the `/health` endpoint of the deployed services. |
| **6️⃣ Notification** | Jenkins outputs a success or failure status, optionally integrating with email, Slack, or other notification channels. |

---

## ⚙️ Tools & Technologies

| Category | Tool |
|-----------|------|
| **CI/CD** | Jenkins (running inside Kubernetes) |
| **Containerization** | Docker |
| **Container Orchestration** | Kubernetes |
| **Configuration Management** | Helm / kubectl |
| **Source Control** | GitHub |
| **Container Registry** | DockerHub |
| **Reverse Proxy** | NGINX |
| **Database** | MySQL / PostgreSQL (as per repo config) |

---

## 🎓 Educational Outcomes
By completing this project, students and DevOps practitioners will learn how to:

✅ Run **Jenkins as a native Pod** inside a Kubernetes cluster.  
✅ Configure **dynamic Jenkins agent Pods** to run CI/CD stages.  
✅ Build, push, and deploy **multi-tier containerized applications**.  
✅ Use **Helm** and **kubectl** for application release management.  
✅ Integrate **GitHub** with Jenkins pipelines for automated workflows.  
✅ Work confidently with **Docker**, **Kubernetes namespaces**, and **container registries**.  

---

## 🌍 Real-World Relevance
This setup reflects **modern DevOps best practices** used by production-grade systems:

- **Cloud-Native Jenkins:** Operates natively on Kubernetes.
- **Dynamic Agents:** Each build runs on disposable, isolated Pods.
- **Scalability:** The pipeline scales horizontally across multiple nodes.
- **Resource Efficiency:** Agents are auto-deleted post-execution.
- **Automation-First Approach:** End-to-end automation — from code commit to deployment.

---

## 🧱 Project Folder Structure (Example)
```

.
├── backend
│   ├── Dockerfile
│   ├── go.mod
│   ├── go.sum
│   └── main.go
├── docker-compose.yaml
├── README.md
├── project2.pdf
├── jenkins
│   ├── ali.txt
│   ├── jenkins-deployment.yaml
│   ├── jenkins-deployment.yml
│   ├── jenkins-pvc.yaml
│   ├── jenkins-rolebinding.yaml
│   ├── jenkins-role.yaml
│   ├── jenkins-sa.yaml
│   └── jenkins-service.yaml
├── Jenkins
├── K8S
│   ├── backend_deployment.yaml
│   ├── backend_service.yaml
│   ├── database_deployment.yaml
│   ├── db-data-pvc.yaml
│   ├── db-data-pv.yaml
│   ├── db-secret.yaml
│   ├── db-service.yaml
│   ├── proxy_deployment.yaml
│   └── proxy_nodeport.yaml
└── nginx
    ├── Dockerfile
    ├── generate-ssl.sh
    ├── nginx.conf
    └── ssl
        ├── selfsigned.crt
        └── selfsigned.key

6 directories, 28 files


````

---

## 🪄 Sample Jenkinsfile Overview
```groovy
pipeline {
    agent any

    environment {
        DOCKERHUB_USER = 'aliwazeer'
        DOCKERHUB_CREDENTIALS = credentials('dockerhub') // Jenkins credential ID
        IMAGE_TAG = "${BUILD_NUMBER}"
        K8S_NAMESPACE = 'dev'
        USE_MINIKUBE = false // true لو عايز تبني على Minikube، false لو هتبني على DockerHub
    }

    stages {

        stage('Checkout Code') {
            steps {
                echo '📦 Fetching source code...'
                checkout scm
            }
        }

        stage('Build & Push Image') {
            steps {
                script {
                    if (env.USE_MINIKUBE == 'true') {
                        echo '🐳 Building Docker image inside Minikube...'
                        sh '''
                            eval $(minikube docker-env)
                            docker build -t backend:${IMAGE_TAG} ./backend
                        '''
                    } else {
                        echo '🚀 Building and pushing image to DockerHub using Kaniko...'
                        sh '''
                            mkdir -p /tmp/.docker

                            cat <<EOF > /tmp/.docker/config.json
                            {
                                "auths": {
                                    "https://index.docker.io/v1/": {
                                        "auth": "$(echo -n "$DOCKERHUB_USER:$DOCKERHUB_CREDENTIALS_PSW" | base64)"
                                    }
                                }
                            }
                            EOF

                            /kaniko/executor \
                              --context ./backend \
                              --dockerfile ./backend/Dockerfile \
                              --destination $DOCKERHUB_USER/backend:$IMAGE_TAG \
                              --cleanup
                        '''
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                echo '☸️ Deploying to Kubernetes...'
                sh '''
                    # إنشاء namespace لو مش موجود
                    kubectl get ns $K8S_NAMESPACE || kubectl create ns $K8S_NAMESPACE

                    # تطبيق ملفات الـ Kubernetes
                    kubectl apply -f K8S/ -n $K8S_NAMESPACE

                    # تحديث صورة backend
                    if [ "$USE_MINIKUBE" = "true" ]; then
                        kubectl set image deployment/backend-deployment backend=backend:${IMAGE_TAG} -n $K8S_NAMESPACE
                    else
                        kubectl set image deployment/backend-deployment backend=$DOCKERHUB_USER/backend:${IMAGE_TAG} -n $K8S_NAMESPACE
                    fi
                '''
            }
        }
    }

    post {
        success {
            echo '✅ Deployment Successful!'
        }
        failure {
            echo '❌ Deployment Failed!'
        }
    }
}
````

---

## 🧩 Namespaces Used

* `jenkins` → Jenkins Master Pod and Agent Pods
* `dev` → Target environment for deploying the 3-tier application

---

## 📈 Future Enhancements

* Integrate **ArgoCD** for GitOps-style deployments
* Add **Prometheus & Grafana** for monitoring Jenkins and application health
* Implement **Slack notifications** for build statuses
* Extend pipeline with **automated integration tests**

---

## 👨‍💻 Author & Credits

**Project Title:** Jenkins Project Scenario – 3-Tier Application CI/CD on Kubernetes
**Repository Reference:** [Ali Wazeer’s Application Source Code](https://github.com/Uliwazeer/project2/)
**Mentor / Reference:** EFG Hermes DevOps Training Project

---

## 🏁 Conclusion

This project delivers a **production-grade CI/CD pipeline** demonstrating how Jenkins and Kubernetes integrate seamlessly to automate builds, tests, and deployments for scalable, multi-tier applications.
It is a complete DevOps hands-on scenario suitable for **interns, students, and professionals** aiming to master **containerized CI/CD pipelines**.

---

### 🛠️ Keywords

`Jenkins` · `Kubernetes` · `CI/CD` · `Docker` · `Helm` · `DevOps` · `Cloud-Native` · `Pipeline` · `3-Tier Application`

`
![WhatsApp Image 2025-11-01 at 10 40 31_dc1fc290](https://github.com/user-attachments/assets/9e427fdd-1b61-4269-81c8-c04352f33749)

<img width="1102" height="121" alt="Screenshot 2025-11-01 045117" src="https://github.com/user-attachments/assets/35f933fd-ffc2-4608-b2e5-6262f09b45bb" />

<img width="729" height="91" alt="Screenshot 2025-11-01 044521" src="https://github.com/user-attachments/assets/2b1d36ec-f796-4ed0-a6ea-8b5849d9a0db" />

<img width="730" height="178" alt="Screenshot 2025-11-01 044213" src="https://github.com/user-attachments/assets/44508837-6ea7-41cc-b085-6b93f96598fa" />

<img width="1366" height="349" alt="Screenshot (529)" src="https://github.com/user-attachments/assets/0ca4a10f-c2b2-45a0-a19f-ce361ade8b5c" />

![WhatsApp Image 2025-11-01 at 15 05 15_ea4d0a49](https://github.com/user-attachments/assets/9bfb7355-6581-41d3-8303-02c2ba245f04)

![WhatsApp Image 2025-11-01 at 15 05 15_e366b5ec](https://github.com/user-attachments/assets/be13a677-4a7d-4f3d-ac88-6b8f2b843f54)

![WhatsApp Image 2025-11-01 at 15 05 15_a3704197](https://github.com/user-attachments/assets/542fc266-8a51-4e49-a74f-1bb369a0fe85)

![WhatsApp Image 2025-11-01 at 15 05 15_a34f86b0](https://github.com/user-attachments/assets/6213df33-9207-472a-98ee-a580720eee74)

![WhatsApp Image 2025-11-01 at 15 05 06_4eae5e8d](https://github.com/user-attachments/assets/5b7264f9-8809-4477-b037-e8ec21a5baa9)

![WhatsApp Image 2025-11-01 at 15 05 02_f943e5b0](https://github.com/user-attachments/assets/164e9a4a-52b4-4ae6-9c44-97c71e2d6b82)

![WhatsApp Image 2025-11-01 at 15 05 02_ea4ee95a](https://github.com/user-attachments/assets/08918041-42b2-41d5-a529-4f4ef69925c5)

![WhatsApp Image 2025-11-01 at 15 05 02_e674e18f](https://github.com/user-attachments/assets/0340111d-6de2-40e3-bfec-9fffb25d7711)

![WhatsApp Image 2025-11-01 at 15 05 02_be595367](https://github.com/user-attachments/assets/165bda09-e62a-448b-965b-500edd138e16)

![WhatsApp Image 2025-11-01 at 15 05 02_22211a82](https://github.com/user-attachments/assets/4a29e126-b114-4892-983b-01b358a19035)

![WhatsApp Image 2025-11-01 at 15 05 02_52bfe18c](https://github.com/user-attachments/assets/f76e499d-943b-45b1-8637-422fca411879)

![WhatsApp Image 2025-11-01 at 15 05 02_8c63331c](https://github.com/user-attachments/assets/77ceaaf5-f74a-44e1-995a-0606f9dfb0e9)




