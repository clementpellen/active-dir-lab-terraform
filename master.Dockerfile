# Pull base image.
FROM ubuntu:latest

RUN \
  # Update
  apt-get update -y && \
  # Install Unzip
  apt-get install unzip -y && \
  # need sudo
  apt-get install sudo -y && \
  # need wget
  apt-get install wget -y && \
  # vim
  apt-get install vim -y && \
  # need curl
  apt-get install curl -y && \
  # need ssh server and client
  apt-get install openssh-server openssh-client -y && \
  # need openssl
  apt-get install openssl -y

################################
# Generate SSH Keys
################################

# Copy the script to the image
COPY ./scripts/generate_ssh_keys.sh /root/scripts/generate_ssh_keys.sh

# Make the script executable
RUN chmod +x /root/scripts/generate_ssh_keys.sh

# Run the script
RUN /root/scripts/generate_ssh_keys.sh

################################
# Install Terraform
################################

# Download terraform for linux
RUN wget https://releases.hashicorp.com/terraform/1.5.7/terraform_1.5.7_linux_amd64.zip

# Unzip
RUN unzip terraform_1.5.7_linux_amd64.zip

# Move to local bin
RUN mv terraform /usr/local/bin/
# Clean up
RUN rm terraform_1.5.7_linux_amd64.zip
# Check that it's installed
RUN terraform --version 

################################
# Install Azure CLI
################################

# Download
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Check that it's installed
RUN az --version

# Connection to Azure
RUN az login --use-device-code

################################
# Install python
################################

# Install python
RUN apt-get install -y python3-pip
RUN pip3 install --upgrade pip

# Check that it's installed
RUN python3 -V
RUN pip --version

################################
# Install Ansible
################################

# Install Ansible
RUN pip install ansible

# Check that it's installed
RUN ansible --version

################################
# Copy the files
################################

# Copy the files
COPY /infrastructure/ /infrastructure/
COPY /src/ /src/

################################
# Run Terraform
################################

# Set the working directory
WORKDIR /infrastructure/terraform

# Init terraform
RUN terraform init

# Plan terraform
# CMD ["terraform", "plan"]
