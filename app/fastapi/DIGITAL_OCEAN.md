# Welcome
This guide contains my notes for deploying this project to Digital Ocean.

Thank you to Rohith ND for writing the [Deploy FastAPI application on Digital Ocean with Nginx and Gunicorn](https://ndrohith09.hashnode.dev/deploy-fastapi-application-on-digital-ocean-with-nginx-and-gunicorn) blog post:

![](./images/thank_you_rohith_nd.png)

For the purposes of this example, my Droplet has been configured as outlined in the blog post and available at the IP address `161.35.228.138`

### Copy files to our Droplet

```sh
# Test the connection to our Droplet
% ssh root@161.35.228.138
Welcome to Ubuntu 22.10 (GNU/Linux 5.19.0-23-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Sat Mar 11 23:38:44 UTC 2023

  System load:  0.0               Users logged in:       0
  Usage of /:   6.9% of 24.06GB   IPv4 address for eth0: 161.35.228.138
  Memory usage: 19%               IPv4 address for eth0: 10.48.0.5
  Swap usage:   0%                IPv4 address for eth1: 10.124.0.2
  Processes:    92

101 updates can be applied immediately.
78 of these updates are standard security updates.
To see these additional updates run: apt list --upgradable


Last login: Sat Mar 11 23:32:22 2023 from 24.19.44.189
root@ubuntu-s-1vcpu-1gb-intel-sfo3-01:~# exit

```

Awesome. Let's get back to our local machine and copy our files over to the `/root` directory on our Droplet:

```sh
# Make sure we're in the top level directory of our project
% pwd
/path/to/explore-python-api-development

# Use rsync to copy and deploy my local files to the remote server
# Exclude virtual environment, cache, and other unnecessary directories
% rsync -av --exclude .venv --exclude .ipynb_checkpoints --exclude __pycache__ fastapi root@161.35.228.138:/root

# Once copying is done you can navigate to `/root/fastapi` path and find your files.
% ssh root@161.35.228.138
root@ubuntu-s-1vcpu-1gb-intel-sfo3-01:~# cd /root/fastapi/
root@ubuntu-s-1vcpu-1gb-intel-sfo3-01:~/fastapi# ls -al
total 36
drwxr-xr-x 3 root root 4096 Mar 11 23:49 .
drwx------ 6 root root 4096 Mar 11 23:49 ..
-rw-r--r-- 1 root root 8196 Mar 11 23:49 .DS_Store
-rw-r--r-- 1 root root 3389 Mar 11 23:49 README.md
drwxr-xr-x 2 root root 4096 Mar 11 23:49 images
-rw-r--r-- 1 root root 2277 Mar 11 23:49 main.py
-rw-r--r-- 1 root root  944 Mar 11 23:49 requirements.txt
root@ubuntu-s-1vcpu-1gb-intel-sfo3-01:~/fastapi# 
```

### Create a virtual environment on our Droplet

```sh
# Connect to our Droplet
% ssh root@161.35.228.138

# Navigate to the files we just copied over
root@ubuntu-s-1vcpu-1gb-intel-sfo3-01:~# cd /root/fastapi/
root@ubuntu-s-1vcpu-1gb-intel-sfo3-01:~/fastapi#

# Create a virtual environment in the /root/fastapi folder
root@ubuntu-s-1vcpu-1gb-intel-sfo3-01:~/fastapi# apt install python3-pip
root@ubuntu-s-1vcpu-1gb-intel-sfo3-01:~/fastapi# pip install virtualenv
root@ubuntu-s-1vcpu-1gb-intel-sfo3-01:~/fastapi# virtualenv venv
root@ubuntu-s-1vcpu-1gb-intel-sfo3-01:~/fastapi# source venv/bin/activate
(venv) root@ubuntu-s-1vcpu-1gb-intel-sfo3-01:~/fastapi# 

# Let's make sure we have our application dependencies installed
(venv) root@ubuntu-s-1vcpu-1gb-intel-sfo3-01:~/fastapi# pip install -r requirements.txt

```

### Nginx Installation

I had to install Nginx on my Droplet by following the guide at [How To Install Nginx on Ubuntu 20.04](https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-ubuntu-20-04):

```sh
# Install Nginx
% sudo apt update
% sudo apt install nginx

# OPTIONAL: Check and see if the firewall is enabled and running
% sudo ufw status
Status: inactive

# Enable the firewall
% sudo ufw enable
Command may disrupt existing ssh connections. Proceed with operation (y|n)? y
Firewall is active and enabled on system startup

# Adjust the firewall
% sudo ufw app list
Available applications:
  Nginx Full
  Nginx HTTP
  Nginx HTTPS
  OpenSSH

# It is recommended that you enable the most restrictive profile that will still allow the traffic you’ve configured. Right now, we will only need to allow traffic on port 80.
% sudo ufw allow 'Nginx HTTP'

# Let's make sure we're allowing HTTP traffic in our firewall on port 80
% sudo ufw status
Status: active

To                         Action      From
--                         ------      ----
Nginx HTTP                 ALLOW       Anywhere                  
Nginx HTTP (v6)            ALLOW       Anywhere (v6)             

```

To serve the application over HTTP we have to make an Nginx config for our application. You can add any name to your app. Here I have specified as `fastapi-demo`:

```sh
(venv) root@ubuntu-s-1vcpu-1gb-intel-sfo3-01:~/fastapi# sudo nano /etc/nginx/sites-available/fastapi-demo
```

Add the following lines to the file - replacing `server_name` with your IP address (`161.35.228.138` in my case)

```
server{
       server_name 161.35.228.138; 
       location / {
           include proxy_params;
           proxy_pass http://127.0.0.1:8000;
       }
}
```

Let's make sure our Nginx service is up and running:

```sh
% systemctl status nginx
● nginx.service - A high performance web server and a reverse proxy server
     Loaded: loaded (/lib/systemd/system/nginx.service; enabled; preset: enabled)
     Active: active (running) since Sun 2023-03-12 00:04:09 UTC; 8min ago
       Docs: man:nginx(8)
    Process: 9266 ExecStartPre=/usr/sbin/nginx -t -q -g daemon on; master_process on; (code=exited, status=0/SUCCESS)
    Process: 9267 ExecStart=/usr/sbin/nginx -g daemon on; master_process on; (code=exited, status=0/SUCCESS)
   Main PID: 9351 (nginx)
      Tasks: 2 (limit: 1116)
     Memory: 5.2M
        CPU: 37ms
     CGroup: /system.slice/nginx.service
             ├─9351 "nginx: master process /usr/sbin/nginx -g daemon on; master_process on;"
             └─9354 "nginx: worker process"
```

Let's open a web browser to our IP address - `161.35.228.138` in this example - at [http://161.35.228.138](http://161.35.228.138).

#### Managing the Nginx Process

Let's review some basic management commands:

```sh
# Stop the web server
% sudo systemctl stop nginx

# Start the web server
% sudo systemctl start nginx

# Stop and start the service again
% sudo systemctl restart nginx

# If you are only making configuration changes, Nginx can often reload without dropping connections
% sudo systemctl reload nginx

# If you want to disable Nginx from starting up automatically at boot
% sudo systemctl disable nginx

# To re-enable the service to automatically start when the system is booted
% sudo systemctl enable nginx
```

> You have now learned basic management commands and should be ready to configure the site to host more than one domain.

#### Setting up Server Blocks

> When using the Nginx web server, _server blocks_ (similar to virtual hosts in Apache) can be used to encapsulate configuration details and host more than one domain from a single server. We will set up a domain called **your_domain**, but you should **replace this with your own domain name**.
> 
> Nginx on Ubuntu 20.04 has one server block enabled by default that is configured to serve documents out of a directory at `/var/www/html`. While this works well for a single site, it can become unwieldy if you are hosting multiple sites. Instead of modifying `/var/www/html`, let’s create a directory structure within `/var/www` for our `your_domain` site, leaving `/var/www/html` in place as the default directory to be served if a client request doesn’t match any other sites.

```sh
# Create the directory for your_domain as follows, using the -p flag to create any necessary parent directories
% sudo mkdir -p /var/www/your_domain/html

# Next, assign ownership of the directory with the $USER environment variable
% sudo chown -R $USER:$USER /var/www/your_domain/html

# To ensure that your permissions are correct and allow the owner to read, write, and execute the files while granting only read and execute permissions to groups and others, you can input the following command
% sudo chmod -R 755 /var/www/your_domain

# Next, create a sample index.html page using nano or your favorite editor
% sudo nano /var/www/your_domain/html/index.html
<html>
    <head>
        <title>Welcome to your_domain!</title>
    </head>
    <body>
        <h1>Success!  The your_domain server block is working!</h1>
    </body>
</html>

# In order for Nginx to serve this content, it’s necessary to create a server block with the correct directives. Instead of modifying the default configuration file directly, let’s make a new one at /etc/nginx/sites-available/your_domain
% sudo nano /etc/nginx/sites-available/your_domain
server {
        listen 80;
        listen [::]:80;

        root /var/www/your_domain/html;
        index index.html index.htm index.nginx-debian.html;

        server_name your_domain www.your_domain;

        location / {
                try_files $uri $uri/ =404;
        }
}

# Notice that we’ve updated the root configuration to our new directory, and the server_name to our domain name.

# Next, let’s enable the file by creating a link from it to the sites-enabled directory, which Nginx reads from during startup
% sudo ln -s /etc/nginx/sites-available/your_domain /etc/nginx/sites-enabled/

```

> Note: Nginx uses a common practice called symbolic links, or symlinks, to track which of your server blocks are enabled. Creating a symlink is like creating a shortcut on disk, so that you could later delete the shortcut from the `sites-enabled` directory while keeping the server block in `sites-available` if you wanted to enable it.

Two server blocks are now enabled and configured to respond to requests based on their listen and server_name directives (you can read more about how Nginx processes these directives here):

- `your_domain`: Will respond to requests for `your_domain` and `www.your_domain`.
- `default`: Will respond to any requests on port 80 that do not match the other two blocks.

To avoid a possible hash bucket memory problem that can arise from adding additional server names, it is necessary to adjust a single value in the `/etc/nginx/nginx.conf` file. Open the file and uncomment the `server_names_hash_bucket_size 64;` line.

```sh
% sudo nano /etc/nginx/nginx.conf
```

Now let's verify our configuration.

```sh
# Verify our configuration is successful
% sudo nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful

# Restart Nginx for the changes to take effect
% sudo systemctl restart nginx
```

### Nginx Configuration
To servee the application over HTTP we have to make an Nginx config for our application. You can add any name to your app. Here I have specified mine to be `fastapi`:

```sh
(venv) root@ubuntu-s-1vcpu-1gb-intel-sfo3-01:~/fastapi# sudo nano /etc/nginx/sites-available/fastapi
```

Be sure to replace `server_name` with the appropriate IP address:

```sh
server{
       server_name 161.35.228.138; 
       location / {
           include proxy_params;
           proxy_pass http://127.0.0.1:8000;
       }
}
```

Next, create a symbloc link to the config file in the `/etc/nginx/sites-enabled` directory and restart Nginx:

```sh
# Create a symbolic link to enable the site
$ sudo ln -s /etc/nginx/sites-available/fastapi /etc/nginx/sites-enabled/

# Restart Nginx
$ sudo systemctl restart nginx.service

# Start the uvicorn server and check if the application is working or not
$ gunicorn -w 4 -k uvicorn.workers.UvicornWorker main:app
```

For this example, I verified that my `plot-iris` endpoint correctly displays a scatter plot at [http://161.35.228.138/plot-iris](http://161.35.228.138/plot-iris):

![](./images/safari_plot-iris-endpoint.png)

Whew! One thing to note is that this application is running but not being automatically restarted if it crashes. We will revisit that next.

### Configure ASGI Server

Now that our application is deployed and configured properly one last thing to do is to create a service for the Gunicorn server so that it is constantly running and it automatically begins when the server is rebooted. Systemd will be used to build the service.

```sh
% ssh root@161.35.228.138
(venv) root@ubuntu-s-1vcpu-1gb-intel-sfo3-01:~/fastapi# deactivate 
root@ubuntu-s-1vcpu-1gb-intel-sfo3-01:~/fastapi# sudo nano /etc/systemd/system/fastapi.service
```

Add the following lines to the new file:

```
[Unit]
Description=Gunicorn instance to serve my FastAPI demo
After=network.target

[Service]
User=<username>
Group=www-data
WorkingDirectory=/root/fastapi
Environment="PATH=/root/fastapi/venv/bin"
ExecStart=/root/fastapi/venv/bin/gunicorn -w 4 -k uvicorn.workers.UvicornWorker main:app

[Install]
WantedBy=multi-user.target

```

After saving the file, let's start the new service:

```sh
root@ubuntu-s-1vcpu-1gb-intel-sfo3-01:~/fastapi# sudo systemctl start fastapi.service
```

Success! I can browse to [http://161.35.228.138/plot-iris](http://161.35.228.138/plot-iris) and see the scatter plot:

![](./images/safari_plot-iris-endpoint.png)
