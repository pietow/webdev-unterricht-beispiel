

### **Exercise: Dockerizing a Django App with Dependencies**

#### **Objective:**
By the end of this exercise, you will:
- Create a Dockerized environment for a Django application with dependencies from `requirements.txt`.
- Understand how to build and run a Django app inside a Docker container.

---

#### **Part 1: Setup the Project Directory**

1. **Create a directory for your Django project:**

   ```bash
   mkdir django_docker_project
   cd django_docker_project
   django-admin startproject django_project .
   ```

2. **Create the required files:**

   - A `requirements.txt` file to define dependencies (pip freeze).
   - A `Dockerfile` to containerize the Django project.



3. **Edit the `Dockerfile` with the following content:**

   ```Dockerfile
   # Use the official Python image as the base image
   FROM python:3.9-slim

   # Set the working directory inside the container
   WORKDIR /app

   # Copy the requirements.txt file into the container
   COPY requirements.txt /app/

   # Install the dependencies
   RUN pip install --no-cache-dir -r requirements.txt

   # Copy the entire project into the container
   COPY . /app/

   # Expose the port that the app will run on (default Django port)
   EXPOSE 8000

   # Run the Django development server
   CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
   ```

---

#### **Part 2: Build the Docker Image**

1. **Build the Docker image using the `Dockerfile`:**

   Inside the `django_docker_project` directory, run the following command:

   ```bash
   docker build -t django_app .
   ```

   This will build the image and install Django inside the container.



#### **Part 4: Run the Django Development Server**

1. **Run the container and start the Django development server:**

   ```bash
   docker run -it -p 8000:8000 django_app
   ```

   This will start the Django development server on port 8000.

---

#### **Part 5: Access the Django App**

1. **Visit the Django app in your browser:**

   Open a browser and go to:

   ```
   http://localhost:8000
   ```

   You should see the default Django welcome page.



