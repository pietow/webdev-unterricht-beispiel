### Bash scripting
- a bash script starts with the following line:

```shell
#!/bin/bash
```

### #!/bin/bash
he line #!/bin/bash at the beginning of a script is known as a shebang (#!) line.
It is used in Unix-like operating systems to indicate which interpreter should be used to execute the script. 

**#!:** This sequence is checked by the Unix/Linux system when the script is executed to determine how the script should be interpreted.

**/bin/bash:** This specifies the path to the Bash shell interpreter. Bash (Bourne Again SHell) is a common command-line shell and scripting language on Unix-like systems.
The path /bin/bash is where the Bash executable is typically located.

When you place #!/bin/bash at the top of a script file and then execute that file, the system uses the Bash shell to interpret and run the script. 

This line must be the first line in the script, with no preceding whitespace.

- The shebang line is only interpreted on Unix-like systems. Windows does not use this mechanism.
- The script file needs to have execute permissions to be run directly (e.g., using chmod +x script.sh).

The path specified in the shebang must be correct and point to a valid interpreter.

For example, if Python is installed in /usr/bin/python3, then a Python script should start with #!/usr/bin/python3.

**example with bash**
```bash
#!/bin/bash

echo 'Hello World'
```

**example with python**

```python
#!/usr/bin/python

print('Hello World')

```

### sudo apt install package -y

**-y flag:** The -y flag is short for --yes and is used to automatically answer "yes" to prompts during the installation process. 

This flag is particularly useful for scripting or automated setups, where you want to avoid manual intervention during package installations.

### python manage.py collectstatic --noinput

**The --noinput** flag is an optional argument that tells Django to run the collectstatic command in a non-interactive mode.

The --noinput flag tells Django to proceed with copying and overwriting these files without waiting for user input (i.e., it automatically answers "yes" to all prompts).

This flag is particularly useful for automated deployment scripts where human interaction is not feasible, and you want the process to run to completion without manual intervention.

**cat with file**

```shell
cat bla.txt
```

- echos back the content of a file

### cat with <<:

In Unix-like systems, the << operator used with cat << EOF is part of shell syntax called a "here document" or **"heredoc"**. 

The << operator is used to redirect input into a command from a block of text in the script or command line itself, rather than from a file or another command. 

**Syntax:** The << operator is followed by a delimiter token, which in your example is EOF. This delimiter is an arbitrary string that you choose to signify the end of the input text.

**Delimiter:** The choice of EOF as a delimiter is conventional; it stands for "End Of File". However, you can use any string as a delimiter, as long as it does not appear in the text itself.

**Heredoc:** Heredocs are typically used with commands that read from standard input, such as cat, text editors (like vi or nano).

**Examples of heredoc**

```shell
nvim <<bla
heredoc> awd
heredoc> bla

cat <<EOF
heredoc> bla
heredoc> gh
heredoc> EOF
```

### Pipe (|)

```shell
command1 | command2
```

### Examples of the pipe

1. List and Count Files: To list files in a directory and count how many files are there:

```shell
ls | wc -l
```

ls lists the files, and wc -l counts the number of lines in the listing, effectively counting the number of files.

2. Search within Files: To search for a specific text pattern within files:

```shell
cat filename.txt | grep 'search_pattern'
```

cat filename.txt outputs the content of filename.txt, and grep 'search_pattern' filters this output to show only lines that contain 'search_pattern'.

3. Search within your history: To search for a specific text pattern within files:

```shell
history | grep 'search_pattern'
```
history outputs your history of command

### Now let's rebuild our django system

#### Steps
1. update OS
2. install python
3. clone repo
4. create virtual  environment
5. install dependencies
6. install gunicorn
7. migrations and collect static files
8. configure and start nginx

```bash
#!/bin/bash

# Update system packages
#sudo apt update

# Install Python 3, pip, and other essentials
#sudo apt install python3 python3-pip python3-venv git -y

CURRENT_USER=$(whoami)
PROJECT_DIR="/home/$CURRENT_USER/myprojectdir"

# Clone your Django project from a repository into 'myprojectdir'
git clone https://github.com/pietow/blog_api_live.git myprojectdir

# Change to your project directory
cd $PROJECT_DIR

# Create a Python virtual environment and activate it
python3 -m venv .venv
source .venv/bin/activate

# Install Gunicorn and other dependencies
pip install -r requirements.txt
pip install gunicorn

# Run Django migrations and collect static files
python manage.py migrate
python manage.py collectstatic --noinput

# Install Nginx
sudo apt install nginx -y

# Create Gunicorn socket file
cat << EOF | sudo tee /etc/systemd/system/gunicorn.socket
[Unit]
Description=gunicorn socket

[Socket]
ListenStream=/run/gunicorn.sock

[Install]
WantedBy=sockets.target
EOF

# Create Gunicorn service file
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

# Start and enable Gunicorn socket and service
sudo systemctl start gunicorn.socket
sudo systemctl enable gunicorn.socket
sudo systemctl start gunicorn
sudo systemctl enable gunicorn

# Fetch the public IP address
PUBLIC_IP=$(curl -s http://ifconfig.me)

# Setup Nginx to Proxy Pass to Gunicorn
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

# Enable the Nginx site configuration

sudo ln -s /etc/nginx/sites-available/myproject /etc/nginx/sites-enabled

sudo usermod -a -G ubuntu www-data
sudo chown -R :www-data ./static
sudo systemctl restart nginx
```