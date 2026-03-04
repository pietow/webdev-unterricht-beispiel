### ** Exercise: Deploy a Dockerized Django App on EC2**
**Objective:** You will set up an AWS EC2 instance, clone a GitHub repository, build a Docker image, and run a Django app inside a container.

---

### ** Task 1: Launch an EC2 Instance**
1. Log in to **AWS Management Console**.
2. Navigate to **EC2** → **Instances** → **Launch Instance**.
3. **Select Amazon Machine Image (AMI):**  
   - Choose **Ubuntu 22.04 LTS**.
4. **Choose Instance Type:**  
   - Select **t2.micro** (Free Tier).
5. **Configure Security Group:**
   - Use the existing security group **wizard-4**.
   - wizard-4 contains:
     - **SSH (port 22)**
     - **HTTP (port 80)**
     - **Custom TCP Rule (port 8000, anywhere 0.0.0.0/0)**
6. **Launch the Instance**.

---

### ** Task 2: Connect to EC2**


### ** Task 3: Install Docker**


### ** Task 4: Clone the Repository**
Now, clone the GitHub repository:

```sh
git clone https://github.com/pietow/docker_django.git
cd docker_django
```

---

### ** Task 5: Build and Run the Docker Container**
1. **Build the Docker image:**
   ```sh
   docker build -t my-django-app .
   ```

2. **Run the Django container:**
   ```sh
   docker run -d -p 8000:8000 my-django-app
   ```

3. Verify it's running:
   ```sh
   docker ps
   ```

---

### **📝 Task 6: Access the Application**
1. Open a web browser and go to:

   ```
   http://your-ec2-public-ip:8000
   ```

2. You should see the running Django application.

---

### **💡 Bonus Task (Optional)**
- Run `docker logs <container_id>` to check logs.
- Stop and remove the container:
  ```sh
  docker stop <container_id>
  docker rm <container_id>
  ```
- Restart the container if needed.

