# Base official image
FROM jenkins/jenkins:latest

USER root

# Install Docker
RUN apt-get update
RUN apt-get install -y ca-certificates curl
RUN install -m 0755 -d /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
RUN chmod a+r /etc/apt/keyrings/docker.asc
RUN echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update
RUN apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Install extra packages
RUN apt-get install -y apt-transport-https software-properties-common  fuse-overlayfs sudo ansible sshpass vim iproute2

# Preinstall plugins
COPY --chown=jenkins:jenkins plugins/ /usr/share/jenkins/ref/plugins/

# Allow jenkins to use docker
RUN usermod -aG sudo jenkins
RUN echo "jenkins ALL=(ALL) NOPASSWD: /usr/bin/sudo, /usr/bin/docker, /usr/bin/sh" >> /etc/sudoers

# Postinstall script
COPY --chown=jenkins:jenkins postinstall.sh /var/jenkins_home/

# Add docker local registry
#COPY ca.crt /etc/docker/certs.d/my.registry:5000/

# Only for tests
#RUN echo "root:password" | chpasswd

USER jenkins