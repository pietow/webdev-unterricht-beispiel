Here’s an exercise that focuses on using Docker images and containers **without using a `Dockerfile` or `docker commit`**. This exercise emphasizes running commands inside containers without saving changes as images.

---

### **Exercise: Running and Working with Docker Containers (Without Dockerfile or Commit)**

#### **Objective:**
By the end of this exercise, you should be able to:
- Pull and run an official Docker image.
- Execute commands inside a container.
- Work with a container interactively.
- Understand the concept of statelessness in containers.

---

#### **Part 1: Pull an Official Image**

1. **Pull the official Python image from Docker Hub:**

   First, let’s pull the official `python` image:

   ```bash
   docker pull python:3.9-slim
   ```

   This will download the Python 3.9-slim image to your local system.

2. **Verify that the image has been pulled:**

   ```bash
   docker images
   ```

   You should see the `python:3.9-slim` image listed.

---

#### **Part 2: Run a Container from the Image**

1. **Run the Python container interactively:**

   ```bash
   docker run -it python:3.9-slim bash
   ```

   - `-it` allows you to interact with the container (interactive mode).
   - `bash` starts a Bash shell inside the container.

2. **Verify that Python is installed inside the container:**

   Inside the container, run the following command:

   ```bash
   python --version
   ```

   You should see Python 3.9.

---

#### **Part 3: Install Dependencies (Temporary)**

1. **Install Flask inside the running container:**

   Inside the container, use `pip` to install Flask:

   ```bash
   pip install Flask
   ```

2. **Create a temporary Flask app and run it:**

   Inside the container, create a simple Flask app:

```bash
echo "from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello():
    return 'Hello from a Docker container!'

if __name__ == '__main__':
    app.run(host='0.0.0.0')" > app.py
```

   Run the Flask app:

   ```bash
   python app.py
   ```

   - The app will start, but since this is running inside the container, you won't see the output unless you forward the ports.

3. **Test accessing the app:**

   Open another terminal and find the container ID by running:

   ```bash
   docker ps
   ```


---

#### **Part 4: Exit and Restart the Container**

1. **Stop the container:**

   In the terminal running the Flask app, press `Ctrl + C` to stop the Flask server.

2. **Exit the container:**

   Type `exit` to leave the interactive shell and stop the container.




