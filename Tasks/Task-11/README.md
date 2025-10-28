# Argo CD Deployment – NGINX Application (via UI)

## Overview

This lab demonstrates how to **install Argo CD** on a running Kubernetes cluster and **deploy an NGINX application** using the **Argo CD web UI**.
All configuration and synchronization were performed through the graphical interface, not the command line.

---

## Objectives

* Install Argo CD in a dedicated namespace.
* Access the Argo CD dashboard through port forwarding.
* Deploy an NGINX application directly from a public GitHub repository.
* Synchronize and verify the deployed resources in the cluster.

---

## Prerequisites

| Requirement        | Description                                              |
| ------------------ | -------------------------------------------------------- |
| Kubernetes Cluster | A running cluster (e.g., Minikube)                       |
| kubectl            | Installed and configured to communicate with the cluster |
| Internet Access    | Required to fetch Argo CD manifests and GitHub resources |
| Web Browser        | To access the Argo CD UI                                 |

---

## Steps

### **Task 1 – Install Argo CD**

1. Create a namespace:

   ```bash
   kubectl create namespace argocd
   ```
2. Deploy the official manifests:

   ```bash
   kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
   ```

### **Task 2 – Access Argo CD UI**

1. Forward the service port:

   ```bash
   kubectl port-forward svc/argocd-server -n argocd 8080:443
   ```
2. Open your browser and go to:
   👉 [https://localhost:8080](https://localhost:8080)
3. Retrieve the admin password:

   ```bash
   kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
   ```
4. Log in using:
   **Username:** `admin`
   **Password:** <retrieved value>

---

### **Task 3 – Create Application (Using UI)**

1. In the Argo CD dashboard, click **“NEW APP”**.
2. Fill in the following:

   * **Application Name:** `nginx-app`
   * **Project:** `default`
   * **Sync Policy:** Manual
   * **Repository URL:** `https://github.com/abdelrahmanonline4/lab-senior`
   * **Path:** `nginx`
   * **Cluster:** `https://kubernetes.default.svc`
   * **Namespace:** `default`
3. Click **Create**.

---

### **Task 4 – Sync the Application**

1. Select your new app in the dashboard.
2. Click **Sync → Synchronize** to deploy manifests into the cluster.

---

### **Task 5 – Verify Deployment**

1. In the GUI, confirm:

   * **Status:** *Synced* ✅
   * **Health:** *Healthy* 💚
2. Optionally verify via CLI:

   ```bash
   kubectl get pods,svc -n default
   ```
3. Access the NGINX app through the exposed service port.

---

## **Expected Deliverables**

* A working Argo CD dashboard with the NGINX app listed.
* Application status shows **Synced** and **Healthy**.
* NGINX accessible via NodePort or LoadBalancer service.

---

## **Directory Reference**

While all actions were UI-based, Argo CD stores its configuration in:

| Path                            | Purpose                                       |
| ------------------------------- | --------------------------------------------- |
| `argocd/` namespace             | Holds all Argo CD pods, secrets, and services |
| `argocd-server`                 | Main web interface component                  |
| `argocd-repo-server`            | Manages repository content                    |
| `argocd-application-controller` | Handles sync and deployment logic             |


<img width="1366" height="484" alt="Screenshot (528)" src="https://github.com/user-attachments/assets/5b392d4d-94d3-422e-ae3d-12b027b61288" />
![WhatsApp Image 2025-10-28 at 21 53 46_fd9048ed](https://github.com/user-attachments/assets/19cee624-281f-40cd-b7e7-4786376168a3)
![WhatsApp Image 2025-10-28 at 21 53 43_f3e738b0](https://github.com/user-attachments/assets/47253ab1-0bb9-4a49-9f78-61503f742f43)
![WhatsApp Image 2025-10-28 at 21 53 43_df9ee9b6](https://github.com/user-attachments/assets/379dc0f0-9958-48a5-b7db-4957e6a7d057)
![WhatsApp Image 2025-10-28 at 21 53 43_2eedf05c](https://github.com/user-attachments/assets/470e74e4-0185-48a4-b6d9-e35ad540ecfa)
![WhatsApp Image 2025-10-28 at 21 53 42_88152f12](https://github.com/user-attachments/assets/e410e549-abf2-423c-acf7-0e9e9ef4a16b)
![WhatsApp Image 2025-10-28 at 21 53 42_30ad4c01](https://github.com/user-attachments/assets/298777fc-45dc-40cb-87b3-4c25bf153f35)
