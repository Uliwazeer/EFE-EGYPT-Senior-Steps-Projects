# Node.js Dockerized Application CI/CD with Jenkins

## 📁 Project Structure

```
Dockerfile
Jenkinsfile
README.md
package.json
package-lock.json
src/
public/
tests/
```

## 🚀 Repository

Main Repository: [https://github.com/Uliwazeer/Task](https://github.com/Uliwazeer/Task)
Sample Minimal Repo: [https://github.com/abdelrahmanonline4/sourcecode](https://github.com/abdelrahmanonline4/sourcecode)

## 🎯 Objective

Automate building, testing, and running a Dockerized Node.js application using Jenkins Pipeline.

## 🔧 Prerequisites

* Jenkins installed and running
* Docker installed on Jenkins host
* Git and Docker Pipeline plugins installed on Jenkins
* Public GitHub repository available

## 📌 Jenkins Pipeline Stages

1. **Checkout** – Clone code from GitHub
2. **Build Docker Image** – Build image using Dockerfile
3. **Run Container** – Run image on port 3000

## 🧩 Jenkinsfile Structure Example

```groovy
pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/Uliwazeer/Task', branch: 'main'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build('nodejs-docker-task')
                }
            }
        }
        stage('Run Container') {
            steps {
                script {
                    dockerImage.run('-p 3000:3000')
                }
            }
        }
    }
}
```

## 🗂 File Descriptions

* **Dockerfile**: Contains instructions to containerize Node.js app
* **Jenkinsfile**: Defines CI/CD pipeline
* **package.json**: Node.js dependencies and scripts
* **src/**: Application logic
* **public/**: Frontend assets
* **tests/**: Automated test files

## ▶ Steps to Execute Pipeline

1. Open Jenkins Dashboard
2. Click **New Item** → Enter `nodejs-docker-pipeline`
3. Select **Pipeline** and click **OK**
4. Under **Pipeline → Definition**, choose `Pipeline script from SCM`
5. Set SCM to **Git** and paste repository URL
6. Save and click **Build Now**
7. Verify container is running:

```bash
docker ps
```

Expected Port: **3000**

## ✅ Verification Checklist

| Task                                                             | Status |
| ---------------------------------------------------------------- | ------ |
| Checkout Successful                                              | ☐      |
| Docker Image Built                                               | ☐      |
| Container Running                                                | ☐      |
| App Accessible at [http://localhost:3000](http://localhost:3000) | ☐      |

## 📸 Documentation Required

* Screenshot of each stage passing
* Screenshot of Docker container running

![WhatsApp Image 2025-10-27 at 21 20 00_7dd19e08](https://github.com/user-attachments/assets/0626623b-b8a6-4bc1-9ddd-740f796ce8d2)
![WhatsApp Image 2025-10-27 at 21 19 56_c4d241c0](https://github.com/user-attachments/assets/c4115d73-873d-49f0-8e20-fd9ae9b00ce9)
![WhatsApp Image 2025-10-27 at 21 19 56_3413b082](https://github.com/user-attachments/assets/6cf0529b-c21c-4398-89a5-5c466d5499e0)
![WhatsApp Image 2025-10-27 at 21 27 29_18b68015](https://github.com/user-attachments/assets/aca830ce-bdb7-441f-a578-a9b3a50e0fa7)
![WhatsApp Image 2025-10-27 at 21 27 28_cf56b9aa](https://github.com/user-attachments/assets/5e7e20b4-15e2-4d42-810b-b5f64211d324)
![WhatsApp Image 2025-10-27 at 21 20 01_f8509f39](https://github.com/user-attachments/assets/54188a87-1e3e-43a2-b180-147f558d2876)
![WhatsApp Image 2025-10-27 at 21 20 00_dbe78640](https://github.com/user-attachments/assets/d95e68ce-430a-418b-b3df-d6f04abab760)
![WhatsApp Image 2025-10-27 at 21 20 00_c1a8aab9](https://github.com/user-attachments/assets/9bf1ea30-4389-4bc6-8aab-67b39cd9ce6e)
![WhatsApp Image 2025-10-27 at 21 20 00_46d85251](https://github.com/user-attachments/assets/40680520-7f08-4427-ac3c-6a575965bb23)
![WhatsApp Image 2025-10-27 at 21 20 00_15d952e7](https://github.com/user-attachments/assets/5e0406a2-68be-4e2e-8e58-b5e7974d01f4)

