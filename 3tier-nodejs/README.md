# 3-Tier Web Application Architecture with Docker Compose

This project demonstrates a robust and scalable 3-tier web application architecture using Docker Compose and best practices for containerization.  The application consists of a frontend, a backend, and a database, each running in its own isolated container. This approach promotes modularity, maintainability, and efficient resource utilization.

## Understanding the 3-Tier Architecture

The 3-tier architecture separates the application into distinct layers:

* **Presentation Tier (Frontend):** This tier is responsible for user interaction and displaying information. In our case, it's a React application that provides the user interface.  It communicates with the backend API to retrieve and display data.
* **Application Tier (Backend):**  This tier handles the application's logic and processes user requests. It acts as an intermediary between the frontend and the database. Our backend is a Node.js application built with Express.js, providing a RESTful API.
* **Data Tier (Database):** This tier is responsible for data storage and retrieval.  We are using MongoDB, a NoSQL document database, to store the application's data.


## Docker Compose: Orchestrating the Application

Docker Compose is a tool for defining and running multi-container Docker applications. It uses a YAML file (`docker-compose.yml`) to configure the application's services, networks, and volumes.  This allows you to easily manage the entire application lifecycle with a single command.

```yaml
version: "3.8"

services:
  backend:
    build: ./3tier-nodejs/backend
    ports:
      - "3001:3001"
    depends_on:
      - mongodb
    environment:
      - MONGO_URI=mongodb://admin:admin@mongodb:27017/admin
    networks:
      - mongo_net

  frontend:
    build: ./3tier-nodejs/frontend
    environment:
      - REACT_APP_API_URL=http://backend:3001/api # Important: Use container name
    ports:
      - "3000:3000"
    depends_on:
      - backend
    networks:
      - mongo_net

  mongodb:
    image: mongo
    environment:
      - MONGO_INITDB_ROOT_USERNAME=admin
      - MONGO_INITDB_ROOT_PASSWORD=admin
    ports:
      - "27017:27017"
    volumes:
      - mongodb_data:/data/db
    networks:
      - mongo_net

volumes:
  mongodb_data:

networks:
  mongo_net:
    driver: bridge
```


**Explanation of Key Elements:**

* **`services`:**  Defines each container in the application.
    * **`build`:** Specifies the path to the Dockerfile used to build the image.
    * **`ports`:** Maps ports between the container and the host machine.
    * **`depends_on`:** Specifies service dependencies, ensuring that containers start in the correct order.  The `frontend` depends on the `backend`, and the `backend` depends on `mongodb`.
    * **`environment`:**  Sets environment variables within the container.  Critically, `MONGO_URI` tells the backend how to connect to the database, and `REACT_APP_API_URL` tells the frontend where the backend API is located. Using the service name (`backend`) for communication within the docker network is essential for proper operation.
    * **`networks`:** Connects containers to a shared network.
* **`volumes`:**  Defines volumes for data persistence. This ensures that data is not lost when containers are stopped or removed. The `mongodb_data` volume stores the MongoDB database files.
* **`networks`:**  Defines networks to enable communication between containers. The `mongo_net` network connects all the services, allowing them to communicate using their service names as hostnames.


## Visualization of the Architecture

The following diagram provides a visual representation of the Docker Compose setup, showing the relationships between the services, networks, and volumes:
![alt text](<docker-compose-graph (4).svg>)


## Dockerfiles: Building the Images

**Backend (./3tier-nodejs/backend/Dockerfile):**

```dockerfile
FROM node:16

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 3001
CMD ["npm", "start"]
```

This Dockerfile builds the backend image using the official Node.js 16 image. It copies the package files, installs dependencies, copies the application code, exposes the port the backend listens on (3001), and sets the command to start the application.

**Frontend (./3tier-nodejs/frontend/Dockerfile):**

```dockerfile
FROM node:16

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

RUN npm run build  # Build the React app for production

EXPOSE 3000

CMD ["serve", "-s", "build"] # Serve the built app using a production server (e.g., serve)

```

This Dockerfile builds the frontend image, also using Node.js 16.  It copies the package files, installs dependencies, copies the application code, builds the React application for production, exposes port 3000, and starts a production-ready web server to serve the built files.




## Accessing the Application

Once the application is running, you can access the frontend in your web browser at:  `http://localhost:3000`


## Stopping the Application

To stop and remove the containers, networks, and (unnamed) volumes:

```bash
docker-compose down
```

The named volume (`mongodb_data`) will persist its data even after running `docker-compose down`.  To remove the volume and its data:

```bash
docker-compose down -v 
```



This comprehensive README provides a thorough explanation of the 3-tier architecture, the Docker Compose setup, visualization, Dockerfiles, and how to run and manage the application. Remember to replace "[PLACEHOLDER FOR GRAPH IMAGE]" with the generated visualization of your docker-compose file.
