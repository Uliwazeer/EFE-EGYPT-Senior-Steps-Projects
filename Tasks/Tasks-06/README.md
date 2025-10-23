# Ansible Lab — Ad‑hoc Commands & Playbook (Package Management with Variables)

> Professional lab guide covering:
> - Part 1: Ad‑hoc Ansible commands for connectivity and package management  
> - Part 2: A playbook demonstrating variables, loops, package/service management, and command result capture

---

## Table of Contents
- Overview
- Prerequisites
- Project layout
- Part 1 — Ad‑hoc Commands (quick operator tasks)
  - 1. Check connectivity
  - 2. Install package (nginx)
  - 3. Verify installation
  - 4. Remove package
- Part 2 — Playbook: `package_manage.yml`
  - Playbook YAML (full)
  - How it works (step explanation)
- Execution: step‑by‑step commands
- Expected outputs (examples)
- Troubleshooting & tips
- License & credits

---

## Overview

This lab teaches common Ansible operations:
- Use ad‑hoc commands to probe hosts and manage packages quickly.
- Write a structured playbook that uses variables, loops, service management, and captures command output into a registered variable.

Two parts:
1. **Ad‑hoc**: fast, one‑off tasks using `ansible` CLI (`ping`, `package`, `service`, `command` modules).
2. **Playbook**: `package_manage.yml` – idempotent automation for removing/adding packages and starting/enabling services.

---

## Prerequisites

- Control machine with **Ansible** installed (Ansible 2.9+ / ansible-core 2.12+ recommended).  
  ```bash
  ansible --version
````

* An inventory file listing your target hosts and reachable over SSH.
* Target hosts reachable and configured with SSH keys or credentials.
* Sudo privileges on target hosts for package/service administration (or will use `--ask-become-pass`).

---

## Project layout (suggested)

```
ansible-lab/
├── inventory                # your inventory file (example below)
├── ad-hoc-examples.sh       # optional: script with ad-hoc commands
├── package_manage.yml       # playbook (Part 2)
└── README.md                # this file
```

---

## Example inventory

Create `inventory` (INI format) in project root:

```ini
[all]
host1 ansible_host=192.168.56.101 ansible_user=youruser
host2 ansible_host=192.168.56.102 ansible_user=youruser

[webservers:children]
all
```

For quick local testing, use `localhost`:

```ini
[all]
localhost ansible_connection=local
```

---

## Part 1 — Ad‑hoc Commands

> Use ad‑hoc commands to perform quick checks and package actions.

### 1. Check connectivity (ping module)

**Purpose:** Verify Ansible can reach all hosts.

```bash
# check connectivity to all hosts in inventory
ansible all -i inventory -m ping
```

**Expected output (success):**

```
host1 | SUCCESS => {"changed":false,"ping":"pong"}
host2 | SUCCESS => {"changed":false,"ping":"pong"}
```

---

### 2. Install nginx on all hosts (package module)

**Purpose:** Install `nginx` using a distribution-neutral module.

```bash
ansible all -i inventory -b -m package -a "name=nginx state=present"
```

* `-b` -> become (use sudo).

**Note:** On RHEL/CentOS the package name might be `nginx` or `nginx` is available via EPEL. On Debian/Ubuntu, package name is `nginx`.

**Expected output (example):**

```
host1 | CHANGED => {"changed": true, ...}
```

---

### 3. Verify installation

**Purpose:** Confirm the package is installed (using shell/command or package facts).

Option A — Check package using `package_facts` (Ansible 2.8+):

```bash
ansible all -i inventory -b -m package_facts
# Then inspect facts, or run a command to grep installed package.
ansible all -i inventory -b -m shell -a "which nginx || nginx -v"
```

Option B — Run `nginx -v` to get version:

```bash
ansible all -i inventory -b -m command -a "nginx -v" --become
```

Expected (stderr/exit code 0):

```
host1 | SUCCESS | rc=0 >>
nginx version: nginx/1.18.0
```

---

### 4. Remove nginx on all hosts

**Purpose:** Demonstrate idempotent removal using `package` module.

```bash
ansible all -i inventory -b -m package -a "name=nginx state=absent"
```

Expected:

```
host1 | CHANGED => {"changed": true, ...}
```

---

## Part 2 — Playbook: Package Management with Variables

**File:** `package_manage.yml` (save in project root)

### Full playbook YAML

```yaml
---
- name: Package management demo (variables, loops, service handling)
  hosts: all
  become: yes
  vars:
    # Main web package
    web_package: nginx

    # List of utility tools to ensure installed
    tools:
      - curl
      - git
      - vim

  tasks:

    - name: Ensure the main web package is absent (remove if present)
      ansible.builtin.package:
        name: "{{ web_package }}"
        state: absent

    - name: Install tools list
      ansible.builtin.package:
        name: "{{ item }}"
        state: present
      loop: "{{ tools }}"
      loop_control:
        label: "{{ item }}"

    - name: Start and enable web service (if package provides a service)
      ansible.builtin.service:
        name: "{{ web_package }}"
        state: started
        enabled: yes
      # Note: On systems where the package does not create a service,
      # this task may fail. Add 'ignore_errors: yes' if desired.

    - name: Check web package version
      ansible.builtin.command: "{{ web_package }} -v"
      register: webpkg_version
      ignore_errors: yes

    - name: Show captured version output
      ansible.builtin.debug:
        msg:
          - "Command: {{ web_package }} -v"
          - "Return code: {{ webpkg_version.rc }}"
          - "Stdout: {{ webpkg_version.stdout | default('') }}"
          - "Stderr: {{ webpkg_version.stderr | default('') }}"
```

### How it works (task by task)

* **vars**: defines `web_package` and `tools` (a list).
* **Ensure main web package absent**: uses `package` to remove `nginx` (demonstrates removal).
* **Install tools**: iterates over `tools` using `loop` and installs each package.
* **Start & enable service**: tries to start and enable a service named `nginx` (if present). Some distributions may not have a service with the same name — be mindful.
* **Check version**: runs `nginx -v` and **registers** output into `webpkg_version`.
* **Debug**: prints the captured version info so you can use it in later tasks or reporting.

---

## Execution — Step‑by‑step Commands

1. **From project root** ensure inventory and playbook exist:

```bash
ls -la
# you should see: inventory  package_manage.yml  README.md
```

2. **Run ad‑hoc ping**

```bash
ansible all -i inventory -m ping
```

3. **Install nginx (ad‑hoc)**

```bash
ansible all -i inventory -b -m package -a "name=nginx state=present"
```

4. **Verify nginx installation (ad‑hoc)**

```bash
ansible all -i inventory -b -m command -a "nginx -v" --become
```

5. **Remove nginx (ad‑hoc)**

```bash
ansible all -i inventory -b -m package -a "name=nginx state=absent"
```

6. **Run the playbook (Part 2)**

```bash
ansible-playbook -i inventory package_manage.yml --ask-become-pass
```

* Enter sudo password when prompted.
* To run without prompt but using stored credentials/ssh setup, omit `--ask-become-pass` and use `--become`.

---

## Expected Playbook Output (example excerpt)

```
PLAY [Package management demo (variables, loops, service handling)] *************

TASK [Gathering Facts] **********************************************************
ok: [host1]
ok: [host2]

TASK [Ensure the main web package is absent (remove if present)] ****************
changed: [host1]
changed: [host2]

TASK [Install tools list] *******************************************************
changed: [host1] => (item=curl)
changed: [host1] => (item=git)
changed: [host1] => (item=vim)
changed: [host2] => (item=curl)
...

TASK [Start and enable web service (if package provides a service)] *************
ok: [host1]
ok: [host2]

TASK [Check web package version] ************************************************
ok: [host1]
ok: [host2]

TASK [Show captured version output] *********************************************
ok: [host1] => {
    "msg": [
        "Command: nginx -v",
        "Return code: 0",
        "Stdout: ",
        "Stderr: nginx version: nginx/1.18.0"
    ]
}

PLAY RECAP **********************************************************************
host1                      : ok=8    changed=4    unreachable=0    failed=0
host2                      : ok=8    changed=4    unreachable=0    failed=0
```

---

## Troubleshooting & Tips

* **Sudo / become errors**: If playbook fails with `sudo: a password is required`, either run with `--ask-become-pass` or configure passwordless sudo for your user (not recommended in production).
* **Package name differences**: Package names differ between distros (e.g., `nginx` vs `nginx-full`). Use group_vars or conditional variables if you target mixed OS families.
* **Service name mismatch**: The service provided by the package may have a different name. If `service` fails, check the actual service name (`systemctl list-units | grep nginx`).
* **Command module failures**: `nginx -v` prints to stderr by design. Use `ignore_errors: yes` and inspect `webpkg_version.stderr`.
* **Idempotence**: The `package` module is idempotent — repeated runs should not produce changes after first successful run.
* **Testing locally**: Use `inventory` with `localhost ansible_connection=local` for development/testing without SSH.

---

## Example quick script (optional)

Create `ad-hoc-examples.sh` for quick ad‑hoc execution (make executable: `chmod +x ad-hoc-examples.sh`):

```bash
#!/usr/bin/env bash
INV=inventory

echo "Ping all hosts"
ansible all -i $INV -m ping

echo "Install nginx"
ansible all -i $INV -b -m package -a "name=nginx state=present"

echo "Check nginx version"
ansible all -i $INV -b -m command -a "nginx -v"

echo "Remove nginx"
ansible all -i $INV -b -m package -a "name=nginx state=absent"
```

---

## Final Notes

This lab helps you demonstrate:

* Practical usage of **ad‑hoc** Ansible modules.
* How to build a clear **playbook** using **variables**, **loops**, **service** management, **command** execution, and **result registration**.
* Reading and presenting the command output via `register` and `debug`.

If you want, I can:

* Add OS detection logic to the playbook to handle Debian vs RHEL flows.
* Provide a `group_vars` example for package/service name abstraction.
* Generate a step‑by‑step video/CLI script tailored to your inventory.

Happy automating! 🚀


