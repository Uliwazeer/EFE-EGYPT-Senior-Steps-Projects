# ⚙️ OpenShift Lab: LimitRange & CronJob Configuration

## 🎯 Objective

As a **Cluster Administrator**, your task is to configure an OpenShift project where:

* Every Pod automatically receives **CPU and Memory requests/limits**.
* Users can **run scheduled Jobs** (e.g., for log rotation or backup tasks).

This lab demonstrates how to enforce resource constraints using a **LimitRange** and how to schedule recurring tasks using a **CronJob**.

---

## 🧩 Step 1 – Create a New Project

Create a new project named **`limitrange-lab`**:

```bash
oc new-project limitrange-lab
```

---

## ⚙️ Step 2 – Define a LimitRange

Create a YAML file named **`limitrange.yaml`** with the following configuration:

```yaml
apiVersion: v1
kind: LimitRange
metadata:
  name: pod-limit-range
  namespace: limitrange-lab
spec:
  limits:
  - type: Container
    max:
      cpu: "1"
      memory: 1Gi
    min:
      cpu: 100m
      memory: 128Mi
    default:
      cpu: 500m
      memory: 512Mi
    defaultRequest:
      cpu: 200m
      memory: 256Mi
```

Apply it:

```bash
oc apply -f limitrange.yaml
```

---

## 🔍 Step 3 – Verify the LimitRange

Check that the LimitRange has been created and is correctly configured:

```bash
oc get limitrange
oc describe limitrange pod-limit-range
```

✅ You should see the correct **min**, **max**, **default**, and **defaultRequest** values.

---

## 🧱 Step 4 – Test with a Pod

Create a simple Nginx Pod without specifying any resource requests or limits:

```bash
oc run nginx --image=nginx --restart=Never
```

Check the applied resources:

```bash
oc get pod nginx -o yaml | grep -A5 "resources:"
```

✅ The default CPU and memory values should be automatically applied from the LimitRange.

---

## ⏱️ Step 5 – Create a CronJob

Create a YAML file named **`cronjob.yaml`** with the following configuration:

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: log-rotation-job
  namespace: limitrange-lab
spec:
  schedule: "*/1 * * * *"   # Runs every minute
  jobTemplate:
    spec:
      template:
        spec:
          restartPolicy: OnFailure
          containers:
          - name: log-task
            image: registry.access.redhat.com/ubi8/ubi
            command: ["sh", "-c", "date; echo 'Task executed'"]
```

Apply it:

```bash
oc apply -f cronjob.yaml
```

---

## ✅ Step 6 – Verify the CronJob

Check that the CronJob exists and is scheduled correctly:

```bash
oc get cronjob
```

You should see:

```
log-rotation-job   */1 * * * *   True
```

List Jobs created by the CronJob:

```bash
oc get jobs
```

---

## 📜 Step 7 – View Job Logs

Find the most recent Pod created by the CronJob and view its logs:

```bash
oc get pods -l job-name=<job-name>
oc logs <pod-name>
```

Expected output:

```
Tue Nov 04 00:34:01 UTC 2025
Task executed
```

---

## 🧾 Deliverables

Each student should provide the following screenshots:

1. `oc describe limitrange` output.
2. Pod YAML showing auto-applied resources.
3. CronJob creation and Job list.
4. Logs confirming successful execution.

---

## 🧹 Cleanup

When finished, delete all lab resources:

```bash
oc delete project limitrange-lab
```

---

## 🏁 Summary

In this lab, you:

* Enforced resource policies using **LimitRange**.
* Verified automatic CPU and Memory assignment to Pods.
* Created and validated a **CronJob** that runs every minute.

This setup helps ensure **resource consistency** and **automated task scheduling** in your OpenShift environment.

