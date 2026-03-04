# CLOUD - DOCKER - 04: Dockerize Django project


# Multi-container apps with Compose
 we'll look at how to deploy multi-container applications using Docker Compose. We usually shorten it to
just Compose.


## Deploying apps with Compose - The TLDR

Modern cloud-native apps are made of multiple smaller services that interact to form a useful app. We call this the
microservices pattern.

A microservices app might have the following seven independent services that work together to form a useful application:

- Web front-end
- Ordering
- Catalog
- Back-end datastore
- Logging

Deploying and managing lots of small microservices like these can be hard.

- Deploying and managing many small microservices can be challenging.
- Docker Compose helps by simplifying the process with a declarative configuration file.
- Instead of using scripts and long Docker commands, Compose lets you describe everything in this configuration file.
- The configuration file can be used to deploy and manage your microservices.
- Once deployed, you can manage the entire lifecycle of your app with a simple set of commands.
- The configuration file can also be stored and managed in a version control system.


# Deploying apps with Compose - Example
We'll divide the Deep Dive section as follows:

- Compose background
- Installing Compose
- Compose files
- Deploying apps with Compose
- Managing apps with Compose


### Dockerizing our Blog API


#### Overview
In this lecture, we will go over the process of Dockerizing a Django app, using a combination of Docker, Gunicorn for handling requests, and Nginx. We will also review the `Dockerfile`, `docker-compose.yml`, and `nginx/default.conf` to understand how each part contributes to the containerized deployment.




#### 1. **Dockerfile** (`/Dockerfile`)
   - **Introduction**: The `Dockerfile` defines the instructions to build the Docker image for the Django app. It specifies the base image, dependencies, project files, and commands to be executed.

```Dockerfile
# Use a lightweight version of Python to minimize image size
FROM python:3.9-slim  

# Set the working directory inside the container
WORKDIR /usr/src/app  

# Systemabhängigkeiten installieren
RUN apt-get update
# Copy the requirements file into the working directory
COPY requirements.txt .  

# Upgrade pip and install Python dependencies
RUN pip install -r requirements.txt  

# Copy the entire project to the container
COPY . . 

# Collect static files for production
RUN python manage.py collectstatic --noinput  

RUN pip install gunicorn

# Open port 8000 for the application
EXPOSE 8000  

# Set the default command to run Gunicorn
CMD ["gunicorn", "--workers", "3", "--bind", "0.0.0.0:8000", "django_project.wsgi:application"]

``` 

BUILD command?

`docker build -t name .`

run command?

`docker run -d -p 8000:8000 name`

- don't forget to set the STATIC_ROOT
- 
   - **Explanation**:
     - **FROM python:3.9-slim**: 
       - Uses a lightweight version of Python (slim) to minimize the image size.
     - **ENV PYTHONUNBUFFERED=1**: 
       - Ensures Python logs are not buffered and are displayed in real-time.
     - **WORKDIR /usr/src/app**: 
       - Sets the working directory to `/usr/src/app`, where the app will be built and executed.
     - **RUN apt-get update && apt-get install -y**: 
       - Installs system dependencies, including:
         - `python3-dev`: Required for compiling Python packages.
         - `libpq-dev`: PostgreSQL dependencies.
     - **COPY requirements.txt .**: 
       - Copies the `requirements.txt` file to the working directory.
     - **RUN pip install --upgrade pip && pip install -r requirements.txt**: 
       - Updates `pip` and installs all Python dependencies.
     - **COPY . .**: 
       - Copies the entire project to the container.
     - **RUN python manage.py collectstatic --noinput**: 
       - Collects static files for serving in production.
     - **RUN python manage.py migrate**: 
       - Runs database migrations to ensure the app is ready to go.
     - **EXPOSE 8000**: 
       - Opens port 8000, where Django will run.
     - **CMD ["gunicorn", "--workers", "3", "--bind", "0.0.0.0:8000", "django_project.wsgi:application"]**: 
       - Sets the default command to run Gunicorn with 3 workers, binding to port 8000.

#### **Nginx ** (`/nginx/default.conf`)
   - **Introduction**: The Nginx configuration file defines how Nginx will act as a reverse proxy, forwarding requests to the Django app running in the `web` container, while also serving static files.

```bash
# nginx/default.conf

server {
    listen 80;

    # Enable detailed error logging
    error_log /var/log/nginx/error.log debug;


    location / {
        proxy_pass http://web:8000;  # Gunicorn running in the `web` container
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /static/ {
        alias /usr/src/app/staticfiles/;  # Path to your static files
    }
}
```

   - **Explanation**:
     - **server { listen 80; }**: 
       - Listens on port 80 for incoming HTTP traffic.
     - **location /static/ { alias /usr/src/app/static/; }**: 
       - Serves static files from the `static` folder inside the container.
     - **location / { proxy_pass http://web:8000; }**: 
       - Forwards all other requests to the Gunicorn service running on port 8000 of the `web` container.
     - **proxy_set_header**: 
       - Passes important headers like the original host and IP address to Gunicorn for proper handling.
       - scheme: HTTP or HTTPS
       - X-Forwarded-For: pass client IP address via many proxies




### Compose background
- Orchard built Fig for managing multi-container Docker apps.  
- Fig, a Python tool, used YAML to define microservices apps.  
- It allowed deploying and managing apps via the `fig` CLI.  
- Fig read YAML and executed the needed Docker commands.  
- Docker, Inc. acquired Orchard and rebranded Fig as Docker Compose.  
- The `fig` CLI was renamed to `docker-compose`.  
- Later, `docker-compose` was integrated into the Docker CLI.

- Now, you can use `docker compose` commands directly in the CLI.  
- The Compose Specification defines multi-container microservices apps.  
- It's an open, community-led standard, separate from Docker’s code.  
- This separation ensures better governance and clear responsibilities.  
- Docker is expected to fully implement the spec in the Docker engine.

### Installing Compose

Compose now ships with the Docker engine and you no longer need to install it as a separate program.

Test it works with the following command. Be sure to use the docker compose command and not docker-compose.

### Compose files

Compose uses YAML files to define microservices applications.

The default name for a Compose YAML file is compose.yaml. However, it also accepts compose.yml and you can use the -f flag to specify custom filenames.



#### 2. **Docker Compose File** (`/docker-compose.yml`)
   - **Introduction**: `docker-compose.yml` is used to define and run multiple containers. It allows us to easily manage both the Django app and Nginx in a declarative way.

   


```bash
# docker-compose.yml
services:
  web:
    build: .
    command: >
      sh -c "python manage.py migrate && 
              gunicorn --workers 3 --bind 0.0.0.0:8000 django_project.wsgi:application"
    volumes:
      - .:/usr/src/app
      - static_volume_live:/usr/src/app/staticfiles
    ports:
      - "8000:8000"
    networks:
      - app-network_live

  nginx:
    image: nginx:latest
    ports:
      - "80:80"
    volumes:
      - ./nginx:/etc/nginx/conf.d
      - static_volume_live:/usr/src/app/staticfiles
    depends_on:
      - web
    networks:
      - app-network_live

volumes:
  static_volume_live:

networks:
  app-network_live:
    name: app-network_live
    driver: bridge
```

- **Explanation**:
     - **web** service:
       - **build**: Specifies that the service will be built using the `Dockerfile`.
       - **command**: Defines the command to start the Django app using Gunicorn.
       - **volumes**: Mounts the app code and static files for persistence.
       - **ports**: Maps port 8000 of the container to port 8000 on the host.
       - **networks**: Connects the service to the `app-network`.
     - **nginx** service:
       - **image**: Uses the latest version of the Nginx container.
       - **ports**: Maps port 80 on the host to port 80 in the container for web traffic.
       - **volumes**: Mounts the Nginx configuration and static files.
       - **depends_on**: Ensures the Nginx container starts only after the web service.
     - **volumes**:
       - **static_volume**: Defines a named volume for persistent static files.
     - **networks**:
       - **app-network**: Specifies the network configuration.



To Dockerize and run your Django app using the setup you've provided, here are the necessary Docker Compose commands you will need:

### 1. **Build the Docker containers**
This command builds the Docker images fo
      - app-network_live

  nginx:
    image: nginx:latest
    ports:
      - "80:80"
    volumes:
      - ./nginx:/etc/nginx/conf.dr the services defined in the `docker-compose.yml` file.

```bash
docker compose build
```

### 2. **Run the containers**
This command starts up all the services defined in `docker-compose.yml` (both `web` and `nginx` services).

```bash
docker compose up
```

### 3. **Run the containers in detached mode**
To run the containers in the background, add the `-d` flag. This is useful for production environments or when you don't want to keep the terminal occupied.

```bash
docker compose up -d
```

### 4. **Stop the containers**
To stop the running containers, use the following command:

```bash
docker compose down
```

### 5. **View logs**
If you want to see the logs of your services, run:

```bash
docker compose logs
```

To view the logs for a specific service (e.g., `web`), use:

```bash
docker compose logs web
```

### 6. **Rebuild the containers after changes**
If you make changes to your `Dockerfile` or project files and want to rebuild the images, use:

```bash
docker compose up --build
```

### 7. **List running containers**
To see the list of containers currently running with Docker Compose, use:

```bash
docker compose ps
```

### 8. **Execute commands in a running container**
If you need to run commands inside a running container (e.g., run database migrations or open a shell), use `exec`. For example, to open a shell inside the `web` container:

```bash
docker compose exec web sh
```

Or to run Django management commands, for example, to run migrations:

```bash
docker compose exec web python manage.py migrate
```

```bash
docker compose build --no-cache
docker compose up -d --force-recreate
```

By following these steps, you will have your Django Blog API containerized and running, with Nginx acting as a reverse proxy and Gunicorn managing requests.