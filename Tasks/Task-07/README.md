# Apache Role — Ansible Role to Deploy a Simple Web Server

> Hands-on project: An Ansible role that installs and configures an Apache web server and deploys a dynamic welcome page using Jinja2 templates.

---

## Overview
This project contains an Ansible role called `apache` that automates the installation and configuration of the **Apache Web Server**. It also deploys a custom welcome page (`index.html`) dynamically rendered using Jinja2.

**Expected Output:** After a successful run, visiting the target server should display:
```

Welcome to <hostname> web server!
Deployed automatically using Ansible Role: Apache

```

---

## Project Structure


roles/
└── apache/
├── defaults/main.yml
├── handlers/main.yml
├── meta/main.yml
├── tasks/main.yml
├── templates/index.html.j2
├── files/
└── vars/main.yml
playbook.yml         # Main playbook
inventory            # Inventory file (example in roles/apache/tests/inventory)

````

---

## Key Files and Their Purpose
- `roles/apache/tasks/main.yml`  
  Defines the main tasks: install Apache, ensure service is running, deploy template, notify handler.

- `roles/apache/handlers/main.yml`  
  Defines the handler: `Restart Apache` triggered when template or configuration changes.

- `roles/apache/templates/index.html.j2`  
  Jinja2 template for the welcome page:
  ```html
  <h1>Welcome to {{ ansible_hostname }} web server!</h1>
  <p>Deployed automatically using Ansible Role: Apache</p>
````

* `playbook.yml` or `site.yml`
  The main playbook that calls the `apache` role for the `webservers` group.

* `inventory`
  Defines the hosts. Example for local testing:

  ```ini
  [webservers]
  localhost ansible_connection=local
  ```

---

## Setup Requirements

1. Ensure Ansible is installed:

   ```bash
   ansible --version
   ```

2. Make sure the folder structure matches the above hierarchy and the `apache` role is present under `roles/`.

3. Ensure you have a valid `inventory` file. A test example exists in `roles/apache/tests/inventory`:

   ```ini
   [webservers]
   localhost ansible_connection=local
   ```

---

## Step-by-Step Execution

> Run all commands from the project root (where `roles/` and `playbook.yml` exist).

### 1. Run playbook using local connection

If no sudo privileges are required:

```bash
ansible-playbook -i apache/tests/inventory playbook.yml --connection=local
```

### 2. Run playbook with sudo (become) privileges

If tasks require elevated permissions (`become: true`):

```bash
ansible-playbook -i apache/tests/inventory playbook.yml --ask-become-pass
```

You will be prompted to enter your sudo password.

### 3. Verify Apache status

```bash
sudo systemctl status apache2     # Ubuntu/Debian
# or
sudo systemctl status httpd       # CentOS/RHEL
```

### 4. Verify welcome page

```bash
curl http://localhost
```

Or open in a browser: `http://localhost`.

---

## Quick Command Summary

```bash
# Generate role skeleton
ansible-galaxy init roles/apache

# Run playbook locally
ansible-playbook -i apache/tests/inventory playbook.yml --connection=local

# Run playbook with sudo
ansible-playbook -i apache/tests/inventory playbook.yml --ask-become-pass

# Check Apache status
sudo systemctl status apache2

# Test welcome page
curl http://localhost
```

---

## Expected Output

### Terminal Output

```
PLAY [webservers] *************************************************************

TASK [Gathering Facts] ********************************************************
ok: [localhost]

TASK [apache : Install Apache Web Server] *************************************
changed: [localhost]

TASK [apache : Ensure Apache is running and enabled] *************************
ok: [localhost]

TASK [apache : Deploy custom welcome page] ***********************************
changed: [localhost]

RUNNING HANDLER [apache : Restart Apache] *************************************
changed: [localhost]

PLAY RECAP ********************************************************************
localhost                  : ok=5    changed=3    unreachable=0    failed=0
```

### Browser / curl Output

Visiting `http://localhost` should return:

```html
<h1>Welcome to my-hostname web server!</h1>
<p>Deployed automatically using Ansible Role: Apache</p>
```

(`my-hostname` will be replaced with the real host name.)

---

## Troubleshooting

### 1. `Unable to parse inventory` or `No hosts matched`

* Ensure you are passing the correct inventory file with `-i path/to/inventory`.
* Ensure the inventory contains a `[webservers]` group.

### 2. `sudo: a password is required`

* Use `--ask-become-pass` to enter sudo password.
* Optionally, configure passwordless sudo for the user (not recommended for production).

### 3. Facts gathering fails

* Usually occurs if sudo is needed. Use `--ask-become-pass` or remove `become: true` for local tests.

### 4. Page not showing / connection refused

* Ensure Apache service is running.
* Check that `index.html` was deployed to the correct directory (typically `/var/www/html`).
* Verify file permissions and ownership (`www-data` or `apache`).

---

## Interview Tips

* Explain **goal**: Automate deployment using reusable Ansible Role (idempotent).
* Mention **role structure**:

  * `tasks/`, `handlers/`, `templates/`, `defaults/`, `vars/`.
* Use of **handlers** to restart service only when needed.
* Local testing with `ansible_connection=local`.
* Handling elevated privileges with `--ask-become-pass`.

---

## Notes

* Simple role, but demonstrates best practices: modularity, idempotence, automated deployment.
* Can be extended to multiple virtual hosts, SSL certificates, firewall rules, or dynamic web apps.



## References

* [Ansible Official Documentation](https://docs.ansible.com/)
* [Ansible Galaxy Roles](https://galaxy.ansible.com/)


![WhatsApp Image 2025-10-24 at 00 04 45_9d2b988b](https://github.com/user-attachments/assets/f9271b9f-67b1-4842-8967-65b136005b46)
![WhatsApp Image 2025-10-24 at 00 04 44_2071a10f](https://github.com/user-attachments/assets/ca920db7-66aa-4254-a14f-fc6e16d68802)
![WhatsApp Image 2025-10-24 at 00 04 44_72af0453](https://github.com/user-attachments/assets/c7cdc6a1-6965-43f4-8623-58d806eb9ad4)
<img width="1366" height="713" alt="Screenshot (522)" src="https://github.com/user-attachments/assets/75fe81bd-4b96-4637-a918-434ba48e0568" />
![WhatsApp Image 2025-10-24 at 00 04 46_4eeb130d](https://github.com/user-attachments/assets/52a07a9e-bb00-418b-b508-efeeccf4a29a)




