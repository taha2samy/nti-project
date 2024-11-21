<p align="center">
  <img src="https://skillicons.dev/icons?i=ansible" style="width:30%;" />
</p>
# Ansible Jenkins Setup

This repository contains an Ansible playbook to automate the installation and configuration of Jenkins on a server. It performs tasks like installing dependencies, setting up the Jenkins repository, configuring Jenkins with plugins, and restarting services as needed.

## Important Warnings

1. **Sensitive Information**:  
   When setting up the **`inventory.ini`** file, be cautious about including sensitive data such as private EC2 keys. The file should look like this:

   ```ini
   [jenkins_server]
   ec2-jenkins ansible_host=<JENKINS_EC2_PUBLIC_IP> ansible_user=ec2 ansible_ssh_private_key_file=/path/to/private-key.pem
   ```

   **Warning**: Ensure the `ansible_ssh_private_key_file` points to your private key and **never share this file** publicly.

2. **Custom Server Configuration**:  
   If your Jenkins EC2 or server requires a different key or path, update the `inventory.ini` accordingly. Ensure the paths and credentials are set correctly to avoid access issues.

Here’s a more detailed **README.md** file, expanded with additional context, instructions, and useful details for running the Ansible playbook and understanding the Jenkins setup process. This version includes instructions for troubleshooting and possible customizations.


# Task 1: Jenkins Setup Process

This documentation outlines the Jenkins setup process using Ansible. The playbook automates the installation and configuration of **Jenkins** on a remote EC2 server. It includes setting up dependencies, installing Jenkins, configuring the necessary plugins, and starting the Jenkins service.

---

## Flowchart Diagram

The flowchart below shows the steps that the Ansible playbook performs when setting up Jenkins:

![Jenkins Setup Flowchart](mermaid-diagram-2024-11-21-214909.svg)

---

## Instructions for Running the Playbook

To run the **Jenkins setup playbook**, follow the steps below:

### 1. **Modify the `inventory.ini` File**

The **`inventory.ini`** file contains critical information required for Ansible to connect to the target server (in this case, the EC2 instance). Ensure that the **public IP address** of the EC2 instance and the path to your **private SSH key** are correctly configured.

Example **`inventory.ini`** configuration:

```ini
[jenkins_server]
ec2-jenkins ansible_host=<JENKINS_EC2_PUBLIC_IP> ansible_user=ec2 ansible_ssh_private_key_file=/path/to/private-key.pem
```

- **`ansible_host`**: Replace `<JENKINS_EC2_PUBLIC_IP>` with your EC2 instance’s public IP address.
- **`ansible_user`**: The username for SSH (in the case of EC2, it's usually `ec2`).
- **`ansible_ssh_private_key_file`**: Path to the private SSH key that Ansible will use to connect to the EC2 instance.

Make sure the private key is accessible from the machine where you are running the playbook.

---

### 2. **Run the Playbook**

Once your **`inventory.ini`** is updated, you can execute the Ansible playbook to set up Jenkins. Run the following command in your terminal:

```bash
ansible-playbook -i inventory.ini playbook_setup_jenkins.yml
```

This command will:
- SSH into the target EC2 instance.
- Update package manager caches.
- Install necessary dependencies (Java, wget, curl).
- Set up Jenkins by installing it and enabling the Jenkins service.
- Install Jenkins plugins and copy configuration files.

---

### 3. **Monitor the Output**

As the playbook runs, monitor the terminal output for progress. You will see the tasks being executed, including any errors if they occur. Common issues might include:

- **SSH Key Issues**: If the private key is incorrect or not accessible, the playbook will fail to connect to the EC2 instance. Ensure that the key path in the **`inventory.ini`** is correct and that the key has the correct permissions (`chmod 400 key.pem`).
  
- **Package Installation Issues**: Ensure the target server has access to the internet for downloading dependencies. If the EC2 instance is behind a proxy, you may need to configure proxy settings.

- **Permissions Issues**: The playbook uses `become: yes`, which means it will run as `sudo` on the target system. If the EC2 user doesn’t have `sudo` privileges, the playbook will fail. Ensure the EC2 user has the necessary privileges.

---

## Customization Options

You may want to customize the Jenkins setup based on your specific needs. Here are some areas where customization is possible:

### 1. **Modify Jenkins Configuration**

The **`jenkins_config.xml`** file is included in the playbook and can be modified to change various Jenkins settings, such as:

- **Number of Executors**: The number of Jenkins agents that will run jobs concurrently.
- **Security Settings**: Enable or disable security, configure user authentication methods, and set user roles.

You can modify this file before running the playbook to suit your environment.

### 2. **Install Additional Jenkins Plugins**

The playbook installs plugins defined in **`jenkins_plugins.txt`**. You can update this file with any plugins you need. Each line in the file should contain the name of a Jenkins plugin, like so:

```
git
workflow-aggregator
docker
kubernetes
```

If you need other plugins, simply add them to the list, and the playbook will install them when executed.

### 3. **Modify Jenkins Dependencies**

If your environment requires additional software (e.g., Maven, Docker), you can extend the playbook by adding more dependencies to the **`Install dependencies`** section. The playbook uses the `ansible.builtin.package` module, which you can update with additional packages.

---

## Troubleshooting

If you run into issues, here are some common problems and solutions:

### **1. Connection Issues**
   - **Error Message**: `Unable to connect to host`
   - **Solution**: Verify that the EC2 instance is accessible via SSH. Check that your security groups and network ACLs allow inbound connections on port 22. Ensure that the path to the SSH private key is correct.

### **2. Package Installation Failures**
   - **Error Message**: `Failed to install Jenkins`
   - **Solution**: Make sure the target EC2 instance has internet access and can reach the repositories specified for Jenkins. If you're using a proxy, configure the proxy settings on the server.

### **3. Jenkins Service Not Starting**
   - **Error Message**: `Jenkins service failed to start`
   - **Solution**: Check the Jenkins logs (`/var/log/jenkins/jenkins.log`) to see why the service failed. It could be due to port conflicts or insufficient system resources.

---


Sure! Below is a detailed `README.md` file for **Task 2**, assuming this task is related to setting up CloudWatch monitoring using Ansible (based on the provided tasks).

---

# Task 2: CloudWatch Agent Installation and Configuration

This task automates the installation and configuration of the **Amazon CloudWatch Agent** on your EC2 instances or other Linux servers using Ansible. The CloudWatch Agent collects system metrics such as CPU, memory, and disk usage and sends them to Amazon CloudWatch for monitoring.

### Flowchart Diagram

Below is a flowchart that represents the steps of Task 2's CloudWatch Agent setup. The playbook ensures that the required dependencies are installed, the CloudWatch Agent package is downloaded and installed, configuration is deployed, and the service is started and enabled.

![alt](mermaid-diagram-2024-11-21-233516.svg)
---

## Instructions for Running the Playbook

Follow these steps to execute the Ansible playbook that installs and configures the CloudWatch Agent:

### 1. Modify the `inventory.ini` File

Before running the playbook, update the `inventory.ini` file with the correct details of the target server(s).

Example `inventory.ini` file:

```ini
[cloudwatch_server]
your-server-name ansible_host=<YOUR_SERVER_IP> ansible_user=<USER> ansible_ssh_private_key_file=<PATH_TO_PRIVATE_KEY>
```

- Replace `<YOUR_SERVER_IP>` with the IP address or hostname of the target server.
- Replace `<USER>` with the appropriate SSH username (e.g., `ec2` for EC2 instances).
- Replace `<PATH_TO_PRIVATE_KEY>` with the path to your SSH private key file that grants access to the server.

### 2. Run the Playbook

To run the playbook and install the CloudWatch Agent, use the following command:

```bash
ansible-playbook -i inventory.ini roles/cloudwatch/tasks/main.yml
```

This command tells Ansible to use the `inventory.ini` file for host details and execute the `main.yml` playbook under the `roles/cloudwatch/tasks/` directory.

### 3. Verify CloudWatch Agent Installation

After running the playbook successfully, verify that the CloudWatch Agent is installed and running by checking its status:

```bash
sudo systemctl status amazon-cloudwatch-agent
```

If everything is set up correctly, you should see the service status as `active (running)`.

### 4. Configure the CloudWatch Agent

- The playbook automatically deploys a configuration template (`config.json.j2`) to the target system. This template is used to configure the CloudWatch Agent to collect specific system metrics such as CPU, memory, and disk usage.

### 5. Monitor CloudWatch Metrics

Once the agent is running, you can monitor the collected metrics in the Amazon CloudWatch console.

- Go to the **CloudWatch Metrics** section of the AWS Console.
- Look for the instance and metrics you configured, such as **CPU Utilization**, **Disk Usage**, and **Memory Usage**.

---

## Playbook Breakdown

### Step 1: Install Dependencies

The playbook first ensures that the required dependencies (such as `wget` and `unzip`) are installed on the target system.

```yaml
- name: Install required dependencies
  ansible.builtin.package:
    name:
      - wget
      - unzip
    state: present
```

### Step 2: Download the CloudWatch Agent Package

The playbook then downloads the appropriate CloudWatch Agent package for the system:

- For **Debian-based** systems, it downloads the `.deb` package.
- For **RHEL-based** systems, it downloads the `.rpm` package.

```yaml
# For Debian-based systems
- name: Download CloudWatch Agent package for Debian-based systems
  ansible.builtin.get_url:
    url: https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
    dest: /tmp/amazon-cloudwatch-agent.deb
  when: ansible_facts['os_family'] == "Debian"

# For RHEL-based systems
- name: Download CloudWatch Agent package for RHEL-based systems
  ansible.builtin.get_url:
    url: https://s3.amazonaws.com/amazoncloudwatch-agent/redhat/amd64/latest/amazon-cloudwatch-agent.rpm
    dest: /tmp/amazon-cloudwatch-agent.rpm
  when: ansible_facts['os_family'] == "RedHat"
```

### Step 3: Install the CloudWatch Agent

The downloaded CloudWatch Agent package is installed using the appropriate package manager (`apt` for Debian or `yum` for RHEL).

```yaml
# For Debian-based systems
- name: Install CloudWatch Agent on Debian-based systems
  ansible.builtin.apt:
    deb: /tmp/amazon-cloudwatch-agent.deb
    state: present
  when: ansible_facts['os_family'] == "Debian"

# For RHEL-based systems
- name: Install CloudWatch Agent on RHEL-based systems
  ansible.builtin.yum:
    name: /tmp/amazon-cloudwatch-agent.rpm
    state: present
  when: ansible_facts['os_family'] == "RedHat"
```

### Step 4: Deploy CloudWatch Agent Configuration

This task uses a Jinja2 template (`config.json.j2`) to create the CloudWatch Agent configuration file, which specifies the metrics to collect and other agent settings.

```yaml
- name: Deploy CloudWatch Agent configuration
  ansible.builtin.template:
    src: config.json.j2
    dest: /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
    owner: root
    group: root
    mode: '0644'
```

### Step 5: Start and Enable the CloudWatch Agent Service

Finally, the playbook starts the CloudWatch Agent service and enables it to start automatically upon boot.

```yaml
- name: Start and enable CloudWatch Agent service
  ansible.builtin.systemd:
    name: amazon-cloudwatch-agent
    enabled: yes
    state: started
```

---

