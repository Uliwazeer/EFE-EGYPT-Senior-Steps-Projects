# 🔐 Running a One-Time Job with Elevated Privileges in OpenShift

## 🎯 Objective

This lab demonstrates how to create and run a one-time **Job** in OpenShift that executes a command requiring **root privileges**.
By default, OpenShift uses restrictive **Security Context Constraints (SCCs)**, preventing containers from running as the root user.
In this exercise, we’ll create a custom **ServiceAccount**, assign it the `anyuid` SCC, and run a privileged Job.

---

## 🧩 Steps Overview

1. **Create a new OpenShift project**
2. **Create a custom ServiceAccount**
3. **Grant the ServiceAccount elevated privileges** using `anyuid` SCC
4. **Create and run a one-time Job** using that ServiceAccount
5. **Verify the Job** execution and privileges
6. **Clean up** resources

---

## 🧱 Step 1 – Create a New Project

```bash
oc new-project elevated-job
```

---

## 👤 Step 2 – Create a ServiceAccount

```bash
oc create sa syscheck-sa
```

Verify creation:

```bash
oc get sa
```

---

## 🔑 Step 3 – Grant Elevated Privileges

Assign the `anyuid` SCC to the ServiceAccount:

```bash
oc adm policy add-scc-to-user anyuid -z syscheck-sa -n elevated-job
```

Confirm:

```bash
oc describe sa syscheck-sa
```

---

## ⚙️ Step 4 – Create the Job

Create a YAML file named **elevated-job.yaml**:

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: syscheck-job
  namespace: elevated-job
spec:
  template:
    spec:
      serviceAccountName: syscheck-sa
      restartPolicy: Never
      containers:
      - name: syscheck
        image: registry.access.redhat.com/ubi8/ubi
        command: ["sh", "-c", "whoami && id && sleep 5"]
```

Apply it:

```bash
oc apply -f elevated-job.yaml
```

---

## 🧾 Step 5 – Verify the Job

Check Job status:

```bash
oc get jobs
```

View Pod logs:

```bash
oc logs -l job-name=syscheck-job
```

Expected output:

```
root
uid=0(root) gid=0(root) groups=0(root)
```

---

## 🧹 Step 6 – Cleanup

```bash
oc delete project elevated-job
```

---

## ✅ Summary

In this lab, we successfully:

* Created a dedicated OpenShift project
* Defined a custom ServiceAccount
* Granted it elevated privileges via the `anyuid` SCC
* Ran a one-time Job as the root user inside a container

This approach is useful for **system checks**, **debug tasks**, or **maintenance operations** that require privileged access in OpenShift.

![WhatsApp Image 2025-11-04 at 20 39 48_3c4c9d7d](https://github.com/user-attachments/assets/334cd92f-0565-42cc-9aec-295e62805ef2)
![WhatsApp Image 2025-11-04 at 20 41 45_239f1664](https://github.com/user-attachments/assets/26e82561-802f-4f3b-ac50-4fc278de45f3)

