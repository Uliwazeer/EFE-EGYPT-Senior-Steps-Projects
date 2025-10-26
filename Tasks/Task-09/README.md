# 🚀 Node.js Dockerization Task

**Branch:** `nodejs-docker-task`

**Don't Forget:** `To Clone Source From Repo https://github.com/abdelrahmanonline4/EFE-Labs-.git`

## 📌 Task Overview

This project demonstrates how to containerize a Node.js application using Docker, deploy it locally, and push it to a specific GitHub branch. The Dockerized application is built to run consistently across environments using a simple and reproducible workflow.

---

## ✅ Objectives

* Dockerize a Node.js application using a custom `Dockerfile`
* Run and verify the container locally
* Push the complete setup to GitHub on the `nodejs-docker-task` branch

---

## 📂 Project Structure

```
.
├── Dockerfile
├── package.json
├── package-lock.json
├── app.js (or server.js)
├── node_modules/ (generated after npm install)
└── README.md
```

---

## 🛠 Dockerization Steps

### **1. Create Dockerfile**

A typical Dockerfile includes:

```dockerfile
# Use official Node.js image
FROM node:18

# Create app directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package*.json ./
RUN npm install

# Copy all files
COPY . .

# Expose application port (e.g., 3000)
EXPOSE 3000

# Start the app
CMD ["npm", "start"]
```

---

## ▶ How to Build and Run the Container Locally

### **Step 1: Build Docker Image**

```bash
docker build -t nodejs-docker-app .
```

### **Step 2: Run Container**

```bash
docker run -p 3000:3000 --name my-node-container nodejs-docker-app
```

### **Step 3: Verify Application**

Open your browser and navigate to:

```
http://localhost:3000
```

You should see the application running successfully.

---

## 🌿 Git Setup & Push Instructions

### **Create and Switch to Branch**

```bash
git checkout -b nodejs-docker-task
```

### **Add and Commit Changes**

```bash
git add .
git commit -m "Added Dockerfile and container setup for Node.js app"
```

### **Push to GitHub**

```bash
git push origin nodejs-docker-task
```

---

## 📸 Deliverables

* ✅ GitHub Repository Link
* ✅ Branch Name: `nodejs-docker-task`
* ✅ Screenshot of the running container on localhost

---

## 📚 Useful Docker Commands

| Command                      | Description             |
| ---------------------------- | ----------------------- |
| `docker ps`                  | List running containers |
| `docker images`              | List available images   |
| `docker stop <container-id>` | Stop running container  |
| `docker rm <container-id>`   | Remove a container      |
| `docker rmi <image-id>`      | Remove an image         |

---

## 🎯 Conclusion

This task demonstrates how to package a Node.js application into a Docker container and deploy it locally. Docker ensures consistency across environments, making the application scalable and easy to distribute.

---

### 🔗 Author

**Ali Wazeer**
DevOps & Cloud Enthusiast 👨‍💻

![WhatsApp Image 2025-10-26 at 21 03 10_3d59123b](https://github.com/user-attachments/assets/1e39a81c-adeb-4e14-a341-53cf7d298a15)


![WhatsApp Image 2025-10-26 at 21 03 10_db3de052](https://github.com/user-attachments/assets/f0f36318-2855-4d96-915c-ea1e8514cad3)


