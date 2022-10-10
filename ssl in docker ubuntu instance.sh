#! /bin/bash
# # update the system
apt update
# # install nginx 
apt install nginx
systemctl status #nginx should be active
# #check ufw list and update if needed
ufw app list
sudo ufw status
ufw allow 'Nginx Full'
ufw allow 'OpenSSH'
ufw allow ' Nginx HTTP'
ufw enable
ufw list
ufw status

# #install ssl and auto update using certbot
apt install certbot python3-certbot-nginx
certbot --nginx -d socket.gaintplay.com


# #(Optional) install docker in you want to deploy docker container
# #  install docker
apt-get install     ca-certificates     curl     gnupg     lsb-release
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin



# # use followoing command to remoce all the docker container and upload new docker image from the docker hub and run it
echo -e "#! /bin/bash\ndocker stop $(docker ps -a -q)\ndocker rm $(docker ps -a -q)\ndocker rmi $(docker images -a -q)\ndocker pull sunil0123/gaintplay-websocket:master\ndocker run -t -d -p 8080:8080 --name linode-docker sunil0123/gaintplay-websocket:master \n">>test.sh

chmod +x update.sh

./update.sh

# # now we have website maped and docker runing in localhost:8080 so change the following code to proxy the website to our localhost:8080

nano /etc/nginx/sites-available/default
# # serch your domain and update the code as   following code  in default file
#      server_name socket.gaintplay.com; # managed by Certbot


#         location / {
#                 # First attempt to serve request as file, then
#                 # as directory, then fall back to displaying a 404.
#                 proxy_pass http://localhost:8080;
#         }

# # restart the service
 systemctl restart nginx.service