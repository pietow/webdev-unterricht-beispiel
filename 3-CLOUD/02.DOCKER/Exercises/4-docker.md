# Deploy a Django project with Gunicorn and Nginx in Docker on an EC2 instance

1. **Deploy Django with Gunicorn in Docker** (without Nginx, static files won't be served).  
2. **Add Nginx with Docker Compose** to serve static files on **port 80**.  

---

## **📝 Exercise: Deploy Django with Gunicorn and Nginx on EC2 Using Docker**

### **📌 Prerequisites**
- An AWS **EC2 instance** (Ubuntu 22.04 recommended).
- **Security Group:** Use `wizard-4` (ensures ports 22, 80, and 8000 are open).
- **Docker Installed** on EC2 (Run `docker --version` to verify).
- **Python & Django App Ready** (or create a simple Django project).

---

## **Part 1: Deploy Django with Gunicorn in Docker (Without Nginx)**
### **Log into EC2 on AWS website**

### **Install Docker**
```sh
sudo apt update && sudo apt install -y docker.io
```

### ** Use an existing Django Project**
If you don’t have a Django project, create a simple one:
```sh
mkdir myproject && cd myproject
python3 -m venv venv
source venv/bin/activate
pip install django gunicorn
django-admin startproject myapp .
```

### ** Create a `Dockerfile`**
Inside the Django project folder, create a `Dockerfile`:
```dockerfile
# Use a lightweight Python image
FROM python:3.9-slim  

# Set the working directory
WORKDIR /usr/src/app  

# Install system dependencies
RUN apt-get update 

# Copy the requirements file and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt  

# Copy the project files
COPY . .

# Expose port 8000
EXPOSE 8000  

# Collect static files (won't be served yet)
RUN python manage.py collectstatic --noinput  

# Run migrations
RUN python manage.py migrate  

# Start the application with Gunicorn
CMD ["gunicorn", "--workers", "3", "--bind", "0.0.0.0:8000", "myapp.wsgi:application"]
```

---

### ** Create a `requirements.txt`**
If not already present, create `requirements.txt`:
```
django
gunicorn
```

---

### ** Build and Run the Docker Container**
```sh
docker build -t my-django-app .
docker run -d -p 8000:8000 --name django-container my-django-app
```

### ** Access the Django App**
- Open a browser and go to **`http://your-ec2-public-ip:8000`**.
- Django should be running (**but static files are not served**).

---

## **Part 2: Add Nginx Using Docker Compose**
Now, we add **Nginx** to serve static files and forward requests to Gunicorn.

### **Create a `docker-compose.yml` File**
In the Django project directory, create `docker-compose.yml`:
```yaml
version: '3.8'

services:
  web:
    build: .
    container_name: django-container
    ports:
      - "8000:8000"
    volumes:
      - static_volume:/usr/src/app/staticfiles
    depends_on:
      - nginx

  nginx:
    image: nginx:latest
    container_name: nginx-container
    restart: always
    ports:
      - "80:80"
    volumes:
      - static_volume:/usr/src/app/staticfiles
      - ./nginx.conf:/etc/nginx/conf.d/default.conf
    depends_on:
      - web

volumes:
  static_volume:
```

---

### ** Create an `nginx.conf` File**
Inside the same directory, create `nginx.conf`:
```nginx
server {
    listen 80;

    location /static/ {
        alias /usr/src/app/staticfiles/;
    }

    location / {
        proxy_pass http://web:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

---

### ** Stop the Standalone Django Container**
Before running `docker-compose`, stop the previous container:
```sh
docker stop django-container
docker rm django-container
```

---

### ** Build and Run Everything with Docker Compose**
```sh
docker compose build --no-cache
docker compose up -d --force-recreate
```

---

### ** Access Django via Nginx**
Now, visit **`http://your-ec2-public-ip`**.  
- **Static files should load properly** because Nginx is handling them.



## **🎯 Student Task Checklist**
✅ **Set up an EC2 instance** and install Docker.  
✅ **Create a Dockerfile** to deploy Django with Gunicorn.  
✅ **Run the Django container** and verify access on port 8000.  
✅ **Write a `docker-compose.yml` file** to include Nginx.  
✅ **Configure Nginx to serve static files** using `nginx.conf`.  
✅ **Run everything with Docker Compose** and access Django on port 80.  



### **🚀 Bonus Challenge (For Advanced Students)**
1. Modify the setup to use **PostgreSQL instead of SQLite**.
2. Use **Docker volumes** for persistent SQLite storage.
3. Secure Nginx with **SSL using Let's Encrypt**.

