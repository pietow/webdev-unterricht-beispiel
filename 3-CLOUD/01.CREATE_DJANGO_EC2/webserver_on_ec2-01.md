
## **Introduction to EC2: Exploring Elastic Compute Cloud**

### **1. Pay-as-You-Go: A New Computing Model**
TEACHER: What is the advantage of cloud?
TEACHER: What is the opposite of Cloud?
One of the most significant shifts brought about by cloud computing is the **pay-as-you-go model**. Before the cloud, organizations had to invest in large amounts of physical hardware upfront, which meant over-provisioning resources to account for future growth.

With EC2 and other cloud services, this approach is flipped on its head:
- You pay only for the compute capacity you use, which means if you need more resources, you can scale up, and if you need less, you can scale down.
- This model significantly reduces costs by allowing businesses to pay only for the infrastructure they need when they need it.

### **2. Promise vs. Cloud: The Evolution of Infrastructure**
TEACHER: WHAT ARE THE DISADVANTAGES OF ON PREMISE IT INFRASTRUCTUR?
In traditional IT infrastructure (the **promise model**), companies had to predict their future computing needs, leading to long-term hardware investments. This created inefficiencies and higher costs due to over or under-provisioning.

**Cloud computing** solves this problem:
- With services like EC2, you don’t need to promise or guess how much capacity you’ll need. Instead, you can launch servers and scale dynamically as your demand grows.
- The cloud offers flexibility and agility, allowing you to adjust your resources based on real-time demand.

### **3. Advantages of EC2**
EC2 stands out among cloud services because it offers several key benefits:
- **Scalability**: You can easily scale your infrastructure to match the needs of your application, ensuring that you are not overpaying for unused capacity.
- **Flexibility**: EC2 supports multiple operating systems, so you can run Linux, Windows, or other OS environments depending on your application’s needs.
- **Elasticity**: Start small and increase capacity only when you need it. EC2 allows for elastic scaling up or down, automatically responding to changes in traffic or workload.
- **Global Infrastructure**: With data centers across the world, EC2 offers low-latency connections, letting you deploy resources closest to your customers.
- **Cost Efficiency**: You can choose various pricing models such as on-demand, reserved instances, or spot instances, giving you the flexibility to manage costs effectively.

### **4. Launching an EC2 Instance: Step-by-Step**
Now, let’s walk through how to **launch an EC2 instance** and run a basic Nginx web server using a simple startup script.

#### **Step 1: Log in to AWS Management Console**
- Navigate to the **EC2 Dashboard** from the AWS console.

#### **Step 2: Launch an Instance**
- Click on **Launch Instance** and choose an **AMI (Amazon Machine Image)** such as **Ubuntu** 
- Choose the instance type, such as **t2.micro**, which is free-tier eligible.

#### **Step 3: Configure Instance Details**
- In the "Configure Instance" section, ensure the **VPC (Virtual Private Cloud)** and **subnet** are set correctly.
- Scroll to the bottom to the **Advanced Details** section, and here is where you’ll input your **user-data script** to automate the configuration.

#### **Step 4: Add Your Script (User Data)**
In the **User Data** field, paste the following script to install Nginx and set up a "Hello World" landing page:

```bash
#!/bin/bash
sudo apt update -y
sudo apt install nginx -y
echo "<h1>Hello World from Nginx on EC2!</h1>" | sudo tee /var/www/html/index.nginx-debian.html
sudo systemctl start nginx
sudo systemctl enable nginx
```

This script will automatically install and start Nginx, and display "Hello World" on your landing page.

#### **Step 5: Configure Security Group**
Ensure that your **security group** allows inbound traffic on **port 80 (HTTP)** and **port 22 (SSH)** so that you can access the Nginx server and SSH into the instance.

#### **Step 6: Review and Launch**
- Review your settings and click **Launch**.
- After the instance launches, you can visit its **public IP address** in a web browser, and you should see the "Hello World from Nginx on EC2!" page.

### **Conclusion**
By following these steps, you’ve learned how to quickly deploy a web server using EC2’s powerful infrastructure. With the flexibility of **pay-as-you-go pricing** and **elastic scalability**, you can now begin building scalable, cost-effective applications. 




# Django deployment

## 1. Manual Deployment:

https://www.digitalocean.com/community/tutorials/how-to-set-up-django-with-postgres-nginx-and-gunicorn-on-ubuntu

**Sockets**
why sockets are crucial:

- Communication: Sockets bridge Nginx (request handling) and Gunicorn (application logic).
- Separation: Sockets enable Nginx and Gunicorn to handle their specific tasks efficiently.
- Speed: Unix sockets provide fast, local communication.
- Scalability: Sockets facilitate load balancing by distributing requests.

**Socket file**

* **Creates a socket:** Sets up a communication point.
* **Path:** Places the socket at `/run/gunicorn.sock`.
* **Startup:** Ensures the socket is active at boot, when sockets are initialized.

Okay, let's add a bit more detail to those bullet points:

- **Creates a Unix domain socket:**
    * Establishes a local communication channel, avoiding network overhead.
    * Uses `ListenStream` for reliable, ordered data flow. STREAM
- **Path: `/run/gunicorn.sock`:**
    * Specifies the file system location where the socket will reside.
    * `/run` indicates a temporary location, cleared on reboot.
    * This is the endpoint that the webserver will use to connect to the application server.
- **Startup: Ensures the socket is active at boot, when sockets are initialized:**
    * `WantedBy=sockets.target` triggers the socket's creation during the system's socket initialization phase.
    * This guarantees the socket is ready before services that depend on it start.
    * This is a systemd unit file that defines the socket.


Here's a breakdown of the Gunicorn service unit in bullet points:

**[Unit]**

- **Description:** Defines the unit as a "gunicorn daemon."
- **Requires=gunicorn.socket:** Specifies that the `gunicorn.socket` unit must be active before this service starts.
- **After=network.target:** Ensures the service starts after network services are initialized.

**[Service]**

- **User=sammy:** Runs the Gunicorn process as the "sammy" user.
- **Group=www-data:** Runs the Gunicorn process with the "www-data" group permissions.
- **WorkingDirectory=/home/sammy/myprojectdir:** Sets the working directory for Gunicorn.
- **ExecStart=...:** Defines the command to start Gunicorn:
    * Uses the Gunicorn executable from the virtual environment: `/home/sammy/myprojectdir/myprojectenv/bin/gunicorn`.
    * Outputs access logs to standard output (`--access-logfile -`).
    * Starts 3 worker processes (`--workers 3`).
    * Binds Gunicorn to the Unix socket: `/run/gunicorn.sock` (`--bind unix:/run/gunicorn.sock`).
    * Specifies the WSGI application: `myproject.wsgi:application`.

**[Install]**


**nginx**

This Nginx server block configuration sets up a reverse proxy to handle requests for a web application. Let's break it down:

* **`server { ... }`**: Defines a server block, which configures how Nginx handles requests for a specific domain or IP address.
* **`listen 80;`**: Tells Nginx to listen for HTTP requests on port 80.
* **`server_name server_domain_or_IP;`**: Specifies the domain name or IP address that this server block applies to. Replace `server_domain_or_IP` with your actual domain or IP.
* **`location = /favicon.ico { access_log off; log_not_found off; }`**:
    * This location block handles requests for the `favicon.ico` file.
    * `=` means an exact match.
    * `access_log off; log_not_found off;` prevents Nginx from logging these requests, which are often numerous and not very informative.
* **`location /static/ { ... }`**:
    * This location block handles requests for static files (e.g., CSS, JavaScript, images) in the `/static/` directory.
    * `root /home/sammy/myprojectdir;` specifies the root directory where these static files are located. Nginx will serve these files directly.
* **`location / { ... }`**:
    * This location block handles all other requests (i.e., requests that don't match the previous location blocks).
    * `include proxy_params;` includes a file with common proxy parameters, such as headers that need to be passed to the backend server.
    * `proxy_pass http://unix:/run/gunicorn.sock;` tells Nginx to forward these requests to the Gunicorn server listening on the Unix domain socket `/run/gunicorn.sock`. **This is the crucial part that sets up the reverse proxy.** Nginx passes requests to Gunicorn for processing.
    * The `http://unix:` part of the proxy pass line specifies that it is a *unix socket* that is being used, and not a standard ip address and port.

- **WantedBy=multi-user.target:** Enables the service to start automatically when the system reaches the multi-user state.



### table comparing Unix domain sockets and network sockets (TCP)in the context of Gunicorn and Nginx:

| Feature | Unix Domain Socket | Network Socket (TCP) |
| :---------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
|   Performance |   Generally faster due to lower overhead (no network protocol stack). |   Slightly slower due to network protocol overhead. |
|   Security |   More secure for local communication. Access control via filesystem permissions. |   Less secure if not properly configured. Requires firewall rules to restrict access. |
|   Local vs. Remote |   Restricted to processes on the same machine. |   Allows communication between processes on different machines. |
|   Complexity |   Simpler configuration for local setups. |   Requires IP address and port configuration. May involve firewall and network configuration. |
|   Overhead |   Lower overhead. |   Higher overhead. |
|   Usage scenario |   Ideal for Nginx and Gunicorn on the same server. |   Necessary when Nginx and Gunicorn run on separate servers, or within containerized network enviroments. |
|   Dependancies |   Relies on the file system. |   Relies on the network stack. |
|   Troubleshooting |   Troubleshooting focuses on file system permissions, and socket file existance. |   Troubleshooting entails network diagnostic, and port availability. |




### ------------ START HERE -------------------------

## 2. Deployment with Bash script
TEACHER: Here’s how you can explain and give background information for each command while manually running the script during your lesson:

---

### 1. **Update System Packages**
```bash
sudo apt update
```
 This command updates the package lists for the system. It fetches information about the newest versions of packages and their dependencies from repositories configured on the system. It ensures that the software you install next is up to date.

### 2. **Install Python, Pip, and Essentials**
```bash
sudo apt install python3 python3-pip python3-venv git -y
```


The `-y` flag automatically answers "yes" to prompts, allowing the installation to proceed without manual intervention.

### 3. **Define Current User and Project Directory**
```bash
CURRENT_USER=$(whoami)
PROJECT_DIR="/home/$CURRENT_USER/myprojectdir"
```

- **`whoami`**: This command captures the current username into a variable.
- **`PROJECT_DIR`**: The project directory path is set dynamically based on the current user, so it can be reused throughout the script.

### 4. **Clone the Django Project**
```bash
git clone https://github.com/pietow/blog_api_live.git myprojectdir
```

This clones the Django project repository from GitHub into a directory called `myprojectdir`. 

**TEACHER:** You can explain that this step assumes the project already exists in a remote Git repository.

### 5. **Change to the Project Directory**
```bash
cd $PROJECT_DIR
```


### 6. **Create and Activate a Virtual Environment**
```bash
python3 -m venv .venv
source .venv/bin/activate
```
**Explanation**: 
- This helps isolate Python packages, so dependencies for this project don’t conflict with other Python projects on the server.


### 7. **Install Dependencies and Gunicorn**
```bash
pip install -r requirements.txt
pip install gunicorn
```
**Explanation**: 
- **`pip install -r requirements.txt`**: This installs all the Python dependencies listed in the `requirements.txt` file. 
- **`pip install gunicorn`**: Installs Gunicorn, which is a Python WSGI HTTP Server that will run the Django application.

### **Introduction to Gunicorn and Why We Need It**

**Gunicorn** is a **Python WSGI HTTP Server** that allows us to run web applications like Django efficiently. It acts as a middle layer between the Django application and a web server like Nginx.

#### **Why Do We Need Gunicorn?**
1. **Django's Development Server Isn't Production-Ready**: 
   Django comes with a built-in development server (`python manage.py runserver`), but it’s not optimized for handling production-level traffic or multiple users. It is designed for development and testing, not for scalability or security in a real-world deployment.

2. **Efficient Request Handling**:
   Gunicorn is designed to handle multiple simultaneous requests. It uses **multiple worker processes**, which allows it to serve many users at the same time without being overwhelmed.

3. **WSGI Compatibility**:
   Gunicorn is a **WSGI-compliant server**. WSGI (Web Server Gateway Interface) is the specification that allows Python web frameworks like Django to communicate with web servers. Gunicorn makes it possible for Nginx to pass HTTP requests to the Django application and receive responses back.

### **What is WSGI?**

**WSGI** stands for **Web Server Gateway Interface**. It is a specification that defines how web servers communicate with web applications written in Python.

#### **Why Was WSGI Created?**
Before WSGI, there was no standard way for Python applications to interact with web servers, which made deploying Python web apps difficult and inconsistent. 
WSGI was created as a **standard interface** that both web servers and Python applications can understand, ensuring compatibility across different Python web frameworks and servers.

#### **How Does WSGI Work?**
WSGI acts as a **middle layer** between the web server (e.g., Nginx or Apache) and the Python web application (e.g., Django, Flask).
It serves as a bridge between the Python web application (like Django) and the web server (like Nginx or Apache), facilitating the process of **translating Python responses into HTTP responses**.


1. **Python Application's Response**:
   When a Python web application (like Django) handles a request, it generates a response. This response is often a **Python object**, such as an instance of `HttpResponse` in Django. This object contains the HTTP status code, headers, and body content (like HTML, JSON, etc.) that should be sent back to the client.

2. **WSGI's Role**:
   The **WSGI server** (like Gunicorn or uWSGI) takes the Python application's response and **translates** it into a format that can be understood by the underlying web server. 



### 8. **Run Migrations and Collect Static Files**
```bash
python manage.py migrate
python manage.py collectstatic --noinput
```
**Explanation**:
- **`python manage.py migrate`**: Applies database migrations to ensure the database schema is up-to-date with the Django models.

- **`python manage.py collectstatic --noinput`**: Collects all static files (CSS, JavaScript, images) into the `static` directory for serving by Nginx. The `--noinput` flag prevents the system from prompting for input.


### Static Files

Static files are the Django community’s term for additional files
commonly served on websites such as CSS, fonts, images, and JavaScript.
Even though we haven’t added any yet to our project, we are already
relying on core Django static files-custom CSS, fonts, images, and
JavaScript-to power the look and feel of the Django admin.

We don’t have to worry about static files for local development because the
web server-run via the runserver command-will automatically find and
serve them for us. 

Here is what static files look like in visual form added to
our existing Django diagram: 

----picture from Static Files----


### Statics in Production

The built-in management command, `collectstatic`, performs this task of
compiling all static files into one location on our file system. 

The location of the static files in our file system is set via **STATIC_ROOT**. 
While we have the flexibility to name this new directory anything we want, traditionally,
it is called staticfiles. 
Here’s how to set things up in our project:

```python
# django_project/settings.py
STATIC_URL = "static/"
STATIC_ROOT = BASE_DIR / "staticfiles" # new
```

Now run python manage.py collectstatic on the command line,
and compile all of our project’s static files into a new root-level directory
called staticfiles.

```python
(.venv) $ python manage.py collectstatic


125 static files copied to '/home/dci-student/PYDCI/DJANGO_PROJECTS/message-board/staticfiles'.
```

If you inspect the new staticfiles directory, it contains a single
directory at the moment, admin, from the built-in admin app powered by
its own CSS, images, and Javascript.

```shell
.
├── django_project
├── posts
│   ├── migrations
├── staticfiles
│   └── admin
│       ├── css
│       ├── img
│       └── js
└── templates

```

If you inspect the new staticfiles directory, it contains a single
directory at the moment, admin, from the built-in admin app powered by 
its own CSS, images, and Javascript. 

- That is important for the deploy of our django project



### 9. **Install Nginx**
```bash
pyth   -y
```

### Nginx Intro

**Nginx** is a powerful, high-performance web server and reverse proxy that is widely used for hosting websites and applications. It excels in handling large amounts of concurrent connections with low resource consumption, making it a great choice for production environments.

### **Why Do We Need Nginx for Our Django Deployment?**

1. **Reverse Proxy**: Nginx acts as a **reverse proxy** that sits in front of your Django application (running with Gunicorn). It handles incoming HTTP requests from clients and forwards them to Gunicorn, allowing Django to focus on processing the application logic.
   
2. **Handling Static Files**: Django is not optimized for serving static files (e.g., CSS, JavaScript, images). Nginx can efficiently serve these **static files** directly to users, freeing up Gunicorn to handle dynamic content (Django views and API responses).

3. **Load Balancing**: Nginx can be used to distribute traffic across multiple Gunicorn instances, improving the scalability and availability of your application by balancing the load.

4. **Security**: Nginx can handle SSL termination (HTTPS) and manage security rules, providing an extra layer of protection between the public internet and your Django app.

5. **Performance**: Nginx is extremely efficient at handling **high traffic volumes**, offloading tasks like handling concurrent requests, caching, and connection management, which improves the overall performance of your Django application.

### **In Summary**:
Nginx plays a crucial role in a Django deployment by acting as a reverse proxy to manage traffic, serve static files, and handle performance and security tasks, while Gunicorn focuses on processing the Django application itself. This combination ensures a scalable, secure, and high-performance deployment.

### 10. **Create Gunicorn Socket File**
```bash
cat << EOF | sudo tee /etc/systemd/system/gunicorn.socket
[Unit]
Description=gunicorn socket

[Socket]
ListenStream=/run/gunicorn.sock

[Install]
WantedBy=sockets.target
EOF
```
**Explanation**: This creates a systemd socket file that tells Gunicorn to listen on the `/run/gunicorn.sock` UNIX socket. This socket will be used for communication between Nginx and Gunicorn.

(we could have also bind to a TCP SOCKET(IP address + Port) instead we used a Unix Domain Socket (File Path)
This is often used when Gunicorn is running behind a reverse proxy (like Nginx), as Unix sockets offer lower latency and higher performance for inter-process communication (IPC) on the same machine.
)

### 11. **Create Gunicorn Service File**
```bash
cat << EOF | sudo tee /etc/systemd/system/gunicorn.service
[Unit]
Description=gunicorn daemon
Requires=gunicorn.socket
After=network.target

[Service]
User=$CURRENT_USER
Group=www-data
WorkingDirectory=$PROJECT_DIR
ExecStart=$PROJECT_DIR/.venv/bin/gunicorn \
          --access-logfile - \
          --workers 3 \
          --bind unix:/run/gunicorn.sock \
          django_project.wsgi:application

[Install]
WantedBy=multi-user.target
EOF
```
**Explanation**: 
- **Gunicorn Service File**: This systemd service file is responsible for managing Gunicorn as a service. It defines how Gunicorn should be started (via the virtual environment, with 3 worker processes, etc.).
- **`ExecStart`**: Specifies the command to run Gunicorn and bind it to the UNIX socket.
- **`User` and `Group`**: Ensures that Gunicorn runs under the correct user and group.

### 12. **Start and Enable Gunicorn**
```bash
sudo systemctl start gunicorn.socket
sudo systemctl enable gunicorn.socket
sudo systemctl start gunicorn
sudo systemctl enable gunicorn
```
**Explanation**: 
- **`start`**: Starts the Gunicorn socket and service.
- **`enable`**: Enables the Gunicorn service to automatically start on boot.

### 13. **Fetch the Public IP Address**
```bash
PUBLIC_IP=$(curl -s http://ifconfig.me)
```
**Explanation**: Fetches the public IP of the EC2 instance to be used in the Nginx configuration.

### 14. **Set Up Nginx to Proxy Pass to Gunicorn**
```bash
cat << EOF | sudo tee /etc/nginx/sites-available/myproject
server {
    listen 80;
    server_name $PUBLIC_IP;  # Set your server's public IP here

    location = /favicon.ico { access_log off; log_not_found off; }
    location /static/ {
        root $PROJECT_DIR;
    }

    location / {
        include proxy_params;
        proxy_pass http://unix:/run/gunicorn.sock;
    }
}
EOF
```
**Explanation**:
- This creates a custom Nginx configuration that listens on port 80 (standard HTTP).
- It configures Nginx to serve static files from the project directory and pass other requests to Gunicorn via the UNIX socket.

### 15. **Enable Nginx Site Configuration**
```bash
sudo ln -s /etc/nginx/sites-available/myproject /etc/nginx/sites-enabled
sudo usermod -a -G ubuntu www-data
sudo chown -R :www-data ./static
sudo systemctl restart nginx
```
**Explanation**:
- **`ln -s`**: Links the Nginx site configuration from the `sites-available` directory to the `sites-enabled` directory, enabling the configuration.
- **`usermod -a -G ubuntu www-data`**: Adds `www-data` (the Nginx user) to the `ubuntu` group, giving it access to project files.
- **`chown -R :www-data ./static`**: Changes the ownership of the static files directory to allow Nginx to serve them.
- **`systemctl restart nginx`**: Restarts Nginx to apply the new configuration.



