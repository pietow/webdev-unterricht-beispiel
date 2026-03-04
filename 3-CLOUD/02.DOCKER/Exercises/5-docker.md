## **Exercise: Adding PostgreSQL to a Django Project with Gunicorn & Nginx**  
### **Objective:**  
- Configure Django to use **PostgreSQL**.
- Use **Gunicorn** as the application server.
- Serve static files via **Nginx**.
- Run everything inside **Docker Compose**.

---

### **1. Set Up the Django Project**  
If you don’t have a Django project yet, create one:

```bash
django-admin startproject django_project
cd django_project
```

Create a virtual environment and install dependencies:

```bash
python -m venv venv
source venv/bin/activate  # Windows: 'venv\Scripts\activate'
pip install django gunicorn psycopg2-binary
```

---

### **2. Update `settings.py` to Use PostgreSQL**  

Open **`django_project/settings.py`** and modify the `DATABASES` setting:

```python
import os

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': os.getenv('POSTGRES_DB', 'mydb'),
        'USER': os.getenv('POSTGRES_USER', 'myuser'),
        'PASSWORD': os.getenv('POSTGRES_PASSWORD', 'mypassword'),
        'HOST': 'postgres',  # Service name in Docker Compose
        'PORT': '5432',
    }
}

# Static files settings
STATIC_URL = '/static/'
STATIC_ROOT = '/usr/src/app/staticfiles'
```

---

### **3. Create `docker-compose.yml`**  

Modify your existing `docker-compose.yml` to include **PostgreSQL**:

```yaml
version: '3.9'

services:
  web:
    build: .
    container_name: django_app
    command: >
      sh -c "python manage.py migrate &&
             gunicorn --workers 3 --bind 0.0.0.0:8000 django_project.wsgi:application"
    volumes:
      - .:/usr/src/app
      - static_volume_live:/usr/src/app/staticfiles
    ports:
      - "8000:8000"
    depends_on:
      - postgres
    networks:
      - app-network_live
    environment:
      - POSTGRES_DB=mydb
      - POSTGRES_USER=myuser
      - POSTGRES_PASSWORD=mypassword

  nginx:
    image: nginx:latest
    container_name: nginx_server
    ports:
      - "80:80"
    volumes:
      - ./nginx:/etc/nginx/conf.d
      - static_volume_live:/usr/src/app/staticfiles
    depends_on:
      - web
    networks:
      - app-network_live

  postgres:
    image: postgres:15
    container_name: postgres_db
    restart: always
    environment:
      POSTGRES_DB: mydb
      POSTGRES_USER: myuser
      POSTGRES_PASSWORD: mypassword
    volumes:
      - postgres_data:/var/lib/postgresql/data
    networks:
      - app-network_live

volumes:
  static_volume_live:
  postgres_data:

networks:
  app-network_live:
    name: app-network_live
    driver: bridge
```

---

### **4. Create a `Dockerfile` for Django**  

Inside your Django project root, create a `Dockerfile`:

```dockerfile
# Use an official Python runtime as base image
FROM python:3.9-slim

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy project files into the container
COPY . .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Collect static files
RUN python manage.py collectstatic --noinput

# Expose port 8000
EXPOSE 8000

# Default command is overridden in docker-compose
CMD ["gunicorn", "--workers", "3", "--bind", "0.0.0.0:8000", "django_project.wsgi:application"]
```

---

### **5. Create a Nginx Configuration File**  

Inside your project, create a `nginx/` directory and add a file **`nginx/default.conf`**:

```nginx
server {
    listen 80;

    location / {
        proxy_pass http://web:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    location /static/ {
        alias /usr/src/app/staticfiles/;
    }
}
```

---

### **6. Run the Project with Docker**  

Start the containers:

```bash
docker compose up --build -d
```

Apply migrations:

```bash
docker compose exec web python manage.py migrate
```

Create a superuser:

```bash
docker compose exec web python manage.py createsuperuser
```

---

### **7. Access the Application**  
- Open **`http://localhost/admin/`** to access the Django admin panel.
- Your app is now served by **Gunicorn** and **Nginx**, with **PostgreSQL** as the database.
