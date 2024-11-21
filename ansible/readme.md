
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

```markdown
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

- **SSH Key Issues**: If the private key is incorrect or not accessible, the playbook will fail to connect to the EC2 instance. Ensure that the key path in the **`inventory.ini`** is correct and that the key has the correct permissions (`chmod 400 /path/to/private-key.pem`).
  
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

## Conclusion

Once the playbook has run successfully, Jenkins will be fully installed and configured on the specified server. You can access Jenkins by navigating to the server’s public IP in your web browser (`http://<JENKINS_EC2_PUBLIC_IP>:8080`).

Feel free to modify the **configuration files** or **playbook tasks** to meet your environment's specific needs. This playbook provides a solid foundation for automating Jenkins setup, but can be extended for more complex requirements.

---

*Happy automating! If you encounter any issues or need further customization, feel free to open an issue or reach out for support.*
```

### Key Enhancements:
- **Expanded troubleshooting section** to help resolve common issues.
- Detailed **customization instructions** for users to modify the Jenkins configuration or add plugins.
- Clearer **instructions for running the playbook**, with additional tips for monitoring the output and troubleshooting errors.

\