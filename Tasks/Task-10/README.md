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

