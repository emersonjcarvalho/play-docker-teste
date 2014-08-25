# Set the base image to Ubuntu:14.04
FROM ubuntu:14.04

# File Author / Maintainer
#MAINTANER By Mitchell Wong Ho <oreomitch@gmail.com>

RUN echo "deb http://archive.ubuntu.com/ubuntu trusty universe" >> /etc/apt/sources.list
RUN apt-get update

# Install and start Runit
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y runit
CMD /usr/sbin/runsvdir-start

# NFS
# RUN DEBIAN_FRONTEND=noninteractive apt-get install nfs-kernel-server

# Never ask for confirmation
ENV DEBIAN_FRONTEND noninteractive

# Add oracle-jdk7 to repositories
RUN apt-get update
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:webupd8team/java -y && \
    apt-get update && \
    echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java7-installer && \
    apt-get install -y oracle-java7-set-default -y

ENV JAVA_HOME /usr/bin/java
ENV PATH $JAVA_HOME:$PATH

#Install Activator
RUN apt-get install -y unzip git
RUN pwd
RUN wget --progress=dot:giga http://downloads.typesafe.com/typesafe-activator/1.2.7/typesafe-activator-1.2.7.zip && \
    mv typesafe-activator*.zip /home/ && \
    cd /home && \
    unzip typesafe*.zip && \
    rm typesafe*.zip && \
    ln -s /home/activator-1.2.7 /home/activator-latest
RUN cd /home/activator-latest/

RUN chmod -rwxr-xr-x /home/activator-1.2.7

# Configure Activator
ENV HOME /home
WORKDIR /home
RUN ls -al ~/
RUN mkdir ~/.activator

### RUN echo '-Dhttp.nonProxyHost="localhost|127.0.0.1"' >> ~/.activator/activatorconfig.txt

# Run activator
RUN ls -al

### Variavel de ambiente ACTIVATOR
ENV ACTIVATOR_HOME /home/activator-1.2.7
ENV PATH $ACTIVATOR_HOME:$PATH

### Clonando App(criando sua pasta) + Dando permissao + entrendo na pasta
RUN cd /home && git clone https://github.com/emersonjcarvalho/play-docker-teste.git && \
    chmod -R 777 /home/play-docker-teste && \    
	cd /home/play-docker-teste/

VOLUME ["/home/activator-latest"]
EXPOSE 9000 8888

### CMD ["/home/activator-latest/activator","ui","-Dhttp.address=0.0.0.0"]
### CMD ["/home/play-docker-teste/activator","run","-Dhttp.address=0.0.0.0"]

### Rodando App
CMD ["/home/play-docker-teste/activator","start"]

## END