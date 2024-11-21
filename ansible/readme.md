
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

## Task 1: Jenkins Setup Process

The flowchart below shows the steps that the Ansible playbook performs when setting up Jenkins:

### Flowchart Diagram

*This image should be generated using the following Mermaid code (or similar tool) to visualize the flow:
![alt text](mermaid-diagram-2024-11-21-213659.svg)
### Instructions for Running the Playbook



1. **Modify the `inventory.ini`**:
   - Ensure the EC2 public IP and path to your private SSH key are correctly set.
   - Example:
     ```ini
     [jenkins_server]
     ec2-jenkins ansible_host=<JENKINS_EC2_PUBLIC_IP> ansible_user=ec2 ansible_ssh_private_key_file=/path/to/private-key.pem
     ```

2. **Run the playbook**:
   Run the following command to apply the playbook:
   ```bash
   ansible-playbook -i inventory.ini playbook_setup_jenkins.yml
   ```

3. **Monitor output**:  
   Watch the output of the playbook to ensure all tasks execute successfully. If the `ansible_ssh_private_key_file` is incorrect or inaccessible, you’ll receive an error.

## Conclusion

Once the playbook runs successfully, Jenkins will be installed and configured on the specified server, ready to use. You can access Jenkins by visiting the server's public IP address.

If you encounter issues, ensure that your server is accessible via SSH and that all necessary dependencies are installed.

*Feel free to modify the configuration as needed for your specific environment or requirements!*
```



