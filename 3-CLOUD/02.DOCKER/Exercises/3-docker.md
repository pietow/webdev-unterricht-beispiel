### **Updated Exercise: Understanding Container Data Persistence & Best Practices on EC2**

#### **Objective:**
1. **Launch and connect to an EC2 instance** (assumed knowledge).
2. **Install Docker** 
3. **Run an Alpine or Ubuntu container** and create a file inside it.
4. **Stop and restart the container** to observe that the file persists (but understand why this is **bad practice**).


### **Step 1: Check Docker Installation**
- Verify Docker installation:
  ```bash
  docker --version
  ```
- If missing, install it:
  ```bash
  sudo apt update && sudo apt install -y docker.io
  ```

---

### **Step 2: Run a Container and Create a File (Bad Practice)**
- Start an **Alpine or Ubuntu container**:
  ```bash
  docker run -dit --name test_container alpine /bin/sh
  ```
  or:
  ```bash
  docker run -dit --name test_container ubuntu /bin/bash
  ```

- Access the container:
  ```bash
  docker exec -it test_container sh
  ```

- Inside the container, create a test file:
  ```bash
  echo "Hello from inside the container!" > /testfile.txt
  exit
  ```

---

### **Step 3: Stop and Restart the Container**
- Stop the container:
  ```bash
  docker stop test_container
  ```

- Restart it:
  ```bash
  docker start test_container
  ```

- Re-enter the container and check if the file still exists:
  ```bash
  docker exec -it test_container sh
  ls /
  cat /testfile.txt
  ```



### **Exercise: Implementing Self-Healing Containers on EC2 with Docker**
#### **Objective:**
1. **Launch and connect to an EC2 instance** (assumed knowledge).
2. **Install Docker** if not already installed.
3. **Run a container with a faulty script** that crashes after a few seconds.
4. **Observe the container’s failure** and manually restart it.
5. **Use Docker's built-in restart policies** to **automate recovery**.
6. **Implement self-healing with Docker Compose & Health Checks**.

---

### **Step 1: Check Docker Installation**
- Verify Docker installation:
  ```bash
  docker --version
  ```
- If missing, install it:
  ```bash
  sudo apt update && sudo apt install -y docker.io
  ```
  or for Amazon Linux:
  ```bash
  sudo yum update -y && sudo yum install -y docker
  sudo systemctl enable docker && sudo systemctl start docker
  sudo usermod -aG docker $USER
  ```

---

### **Step 2: Run a Container That Fails**
- Start a container that **crashes after 10 seconds**:
  ```bash
  docker run --name crash_test alpine sh -c "echo 'Running...'; sleep 3; echo 'Crashing now!'; exit 1"
  ```

- Observe the logs:
  ```bash
  docker logs -f crash_test
  ```
  
- Check the container status:
  ```bash
  docker ps -a
  ```

🔹 **Observation:** The container exits after 10 seconds and does not restart.

---

### **Step 3: Restart the Container Manually (Bad Practice)**
- Restart the container manually:
  ```bash
  docker start crash_test
  ```
- Wait for it to crash again.

🔹 **Discussion:**  
- Manually restarting failed containers is inefficient.
- We need **self-healing** mechanisms.

---

### **Step 4: Use Docker’s Built-in Restart Policies**
- Remove the previous container:
  ```bash
  docker rm crash_test
  ```

- Start a new container with a **restart policy**:
  ```bash
  docker run -dit --name self_healing_test --restart always alpine sh -c "echo 'Running...'; sleep 1; echo 'Crashing now!'; exit 1"
  ```

- Watch it restart automatically:
  ```bash
  docker ps -a
  ```



### **Exercise: Implementing Self-Healing Containers with `on-failure` Restart Policy**  

#### **Objective:**  
Students will:  
1. **Launch and connect to an EC2 instance** (assumed knowledge).  
2. **Install Docker** (if not installed).  
3. **Run a container that crashes** after a few seconds.  
4. **Use the `on-failure` restart policy** to allow automatic recovery.  
5. **Analyze the container restart behavior** and tweak restart limits.  

---

### **Step 1: Verify Docker Installation**
- Check if Docker is installed:  
  ```bash
  docker --version
  ```
- If not installed, install it:  
  ```bash
  sudo apt update && sudo apt install -y docker.io
  ```
  or for Amazon Linux:  
  ```bash
  sudo yum update -y && sudo yum install -y docker
  sudo systemctl enable docker && sudo systemctl start docker
  sudo usermod -aG docker $USER
  ```

---

### **Step 2: Run a Container That Fails**
- Start a **container that crashes after 10 seconds**:
  ```bash
  docker run --name failure_test alpine sh -c "echo 'Running...'; sleep 10; echo 'Crashing now!'; exit 1"
  ```
- Observe the container logs:
  ```bash
  docker logs -f failure_test
  ```
- Check the container status:
  ```bash
  docker ps -a
  ```

🔹 **Observation:** The container **exits** after 10 seconds and does not restart.

---

### **Step 3: Apply the `on-failure` Restart Policy**
- Remove the previous container:
  ```bash
  docker rm failure_test
  ```

- Start a new container with the `on-failure` restart policy:
  ```bash
  docker run -dit --name failure_test --restart on-failure alpine sh -c "echo 'Running...'; sleep 10; echo 'Crashing now!'; exit 1"
  ```

- Observe what happens after 10 seconds:
  ```bash
  docker ps -a
  ```

🔹 **Expected Behavior:**  
- The container **automatically restarts** after crashing.
- Docker will only **restart it if it exits with an error** (`exit 1`).
- If the container **exits successfully** (`exit 0`), it won’t restart.

---

### **Step 4: Limit the Number of Restarts**
- Remove the old container:
  ```bash
  docker rm -f failure_test
  ```

- Start a new container that **only retries 3 times**:
  ```bash
  docker run -dit --name failure_limited --restart on-failure:3 alpine sh -c "echo 'Running...'; sleep 10; echo 'Crashing now!'; exit 1"
  ```

- Observe the restart behavior:
  ```bash
  docker ps -a
  ```
