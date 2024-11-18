# Kubernetes Deployment for 3-Tier Node.js Application

This repository contains the necessary configurations and Kubernetes manifests to deploy a 3-tier Node.js application on Kubernetes. The application consists of a frontend (React), backend (Node.js), and a MongoDB database. The setup is optimized for scalability, maintainability, and ease of deployment.

## Project Structure

```plaintext
kubernetes/
├── configmaps/
│   ├── application-configmap.yaml    # ConfigMap for general application settings
│   ├── backend-configmap.yaml       # ConfigMap for backend environment variables
│   └── frontend-configmap.yaml      # ConfigMap for frontend environment variables
├── deployments/
│   ├── backend-deployment.yaml      # Deployment configuration for the backend
│   ├── frontend-deployment.yaml     # Deployment configuration for the frontend
│   ├── mongodb-deployment.yaml      # Deployment configuration for MongoDB
│   └── mongodb-pvc.yaml             # Persistent Volume Claim for MongoDB data
└── services/
    ├── backend-service.yaml         # Service configuration for the backend
    ├── frontend-service.yaml        # Service configuration for the frontend
    └── mongodb-service.yaml         # Service configuration for MongoDB
```

## Prerequisites

Before deploying the application, ensure that you have the following:

- **Kubernetes Cluster**: A working Kubernetes cluster (e.g., minikube, GKE, AKS, EKS).
- **kubectl**: Command-line tool configured to interact with your Kubernetes cluster.
- **Docker Images**: Built and pushed the Docker images for frontend and backend applications.

## Setup Instructions

Follow these steps to deploy the 3-tier Node.js application on Kubernetes:

### 1. Apply ConfigMaps

ConfigMaps store configuration data for the backend, frontend, and general application settings. Apply the following ConfigMaps:

```bash
kubectl apply -f kubernetes/configmaps/backend-configmap.yaml
kubectl apply -f kubernetes/configmaps/frontend-configmap.yaml
kubectl apply -f kubernetes/configmaps/application-configmap.yaml
```

### 2. Apply Deployments

Next, deploy the backend, frontend, and MongoDB components to Kubernetes:

```bash
kubectl apply -f kubernetes/deployments/mongodb-deployment.yaml
kubectl apply -f kubernetes/deployments/backend-deployment.yaml
kubectl apply -f kubernetes/deployments/frontend-deployment.yaml
```

### 3. Apply Persistent Volume Claim for MongoDB

MongoDB needs persistent storage for data. Apply the persistent volume claim:

```bash
kubectl apply -f kubernetes/deployments/mongodb-pvc.yaml
```

### 4. Apply Services

Expose the frontend, backend, and MongoDB services to facilitate communication between components:

```bash
kubectl apply -f kubernetes/services/mongodb-service.yaml
kubectl apply -f kubernetes/services/backend-service.yaml
kubectl apply -f kubernetes/services/frontend-service.yaml
```

### 5. Verify the Deployment

After applying the configurations, verify that all resources have been successfully deployed:

```bash
kubectl get pods
kubectl get services
kubectl get deployments
```

Check if the pods are running and the services are properly exposed. You can use the `kubectl describe pod <pod-name>` command to inspect the status and logs of individual pods if necessary.

### 6. Access the Application

- **Frontend**: If using a `NodePort` or LoadBalancer type service for the frontend, access the frontend application via the assigned node port or external IP.
- **Backend**: The backend service is exposed internally and will be used by the frontend application to make API calls.

### 7. Cleanup

To clean up the resources after testing or once you're done, use the following command:

```bash
kubectl delete -f kubernetes/
```

This will remove all Kubernetes deployments, services, and other resources associated with the project.

## Notes

- If you're using a cloud provider like GKE, EKS, or AKS, ensure that you have the necessary external IP configurations to access the application externally.
- The frontend is configured to communicate with the backend API via environment variables defined in the ConfigMap. Make sure that the `REACT_APP_API_URL` variable points to the correct backend URL.

## Conclusion

This setup enables you to deploy a 3-tier Node.js application using Kubernetes, offering scalability and containerization benefits for each layer of the application (frontend, backend, and database). Ensure to modify the environment variables and configurations based on your specific needs.

For more information on Kubernetes, refer to the [Kubernetes Documentation](https://kubernetes.io/docs/).
```

