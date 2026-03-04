## AWS EC2 & Docker Exercise: Deploying Nginx (AWS Console Terminal)

**Objective:** This exercise guides you through creating an EC2 instance on AWS, installing Docker, and deploying a simple Nginx web server accessible via the instance's public IP address, all directly from the AWS Console using its built-in terminal.

**Prerequisites:**

* An AWS account with appropriate permissions to create EC2 instances and security groups.
* Basic understanding of Linux command-line interface.
* Basic understanding of Docker concepts.

**Steps:**

**1. Launch an EC2 Instance:**

* Log in to the AWS Management Console and navigate to the EC2 service.
* Click "Launch Instance."
* Choose an Amazon Machine Image (AMI):
    * Search for and select "Ubuntu" (e.g., Ubuntu 22.04 LTS).
    * Choose a "Free tier eligible" instance type (e.g., t2.micro or t3.micro).
* Configure Instance Details:
    * Accept the default settings for most options.
* Add Storage:
    * Accept the default storage size.
* Add Tags (Optional):
    * Add tags like Name and Environment to help organize your resources.
* Configure Security Group:
    * Create a new security group or select an existing one.
    * **Crucially, add the following inbound rules:**
        * **SSH:** Type: SSH, Port range: 22, Source: My IP (or Anywhere if needed for testing, but be cautious).
        * **HTTP:** Type: HTTP, Port range: 80, Source: Anywhere (0.0.0.0/0).
    * This will allow SSH access for management and HTTP access to the Nginx server.
* Review and Launch:
    * Review the instance details and click "Launch."
    * When prompted to create a key pair, select "Proceed without a key pair (Not recommended)." This is for simplicity in this exercise, but understand that in production, key pairs are crucial.
* Wait for the instance to launch and obtain its public IP address.

**2. Connect to the EC2 Instance using AWS Console Terminal:**

* Go to the EC2 Instances page.
* Select the instance you just launched.
* Click the "Connect" button.
* Choose the "EC2 Instance Connect" tab.
* Click the "Connect" button. This will open a browser-based terminal connected to your EC2 instance.

**3. Install Docker:**

* Update the package repositories:

```bash
sudo apt update -y
```

* Install Docker:

```bash
sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker
```

* Add the `ubuntu` user to the `docker` group to avoid using `sudo` with Docker commands:

```bash
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
```

* Verify docker is installed.
    ```bash
    docker --version
    ```

**4. Run the Nginx Docker Container:**

* Run the Nginx container, mapping port 80 of the container to port 80 of the host:

```bash
docker run -d -p 80:80 nginx
```

* Verify the container is running:

```bash
docker ps
```

**5. Access the Nginx Landing Page:**

* Open a web browser and enter the public IP address of your EC2 instance in the address bar.
* You should see the default Nginx welcome page.

**6. Clean Up (Important!):**

* **Stop and terminate the EC2 instance** to avoid incurring unnecessary charges.
* **Delete the security group** if you created a new one specifically for this exercise.

**Grading Criteria:**

* Successful launch of an EC2 instance.
* Successful connection to the instance via AWS Console Terminal.
* Successful installation of Docker.
* Successful deployment of the Nginx container.
* Accessibility of the Nginx landing page via the instance's public IP address.
* Proper cleanup of the resources.
* Correct security group configuration.

**Extension Activities:**

* Customize the Nginx landing page by mounting a custom HTML file into the container.
* Deploy a more complex application using Docker Compose.
* Explore other Docker features, such as Docker volumes and networks.
* Use a Dockerfile to create a custom image.
* Use Elastic IP addresses.
* Explore AWS Systems manager to install docker.
