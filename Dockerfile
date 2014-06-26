#run ex;
# sudo docker run -d -p 3002:3000 drjerm/ubuntu-portfolio

# DOCKER_VERSION 1.0.0

FROM ubuntu:latest

MAINTAINER Jeremy R Bernstein <utilityjerm@gmail.com>

# Install nodejs
RUN apt-get install -y -q software-properties-common
RUN add-apt-repository -y ppa:chris-lea/node.js
RUN apt-get -y update
RUN apt-get install -y -q nodejs

# Move files into the container
RUN mkdir /var/deploy
ADD . /var/deploy

# Install npm dependencies
RUN cd /var/deploy; /usr/bin/npm install --production

# Start the server
EXPOSE 3000
CMD cd /var/deploy && node server.js
