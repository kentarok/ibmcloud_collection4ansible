#
# docker build -t ansible . -f Dockerfile.
# docker run -d -it -v $(pwd):/ansible --env-file ./my_env_file.txt --name ansible ansible
# docker exec -it ansible /bin/bash
#
FROM python:3.6

ARG terraform="https://releases.hashicorp.com/terraform/0.12.20/terraform_0.12.20_linux_amd64.zip"
ARG terraplugin="https://github.com/IBM-Cloud/terraform-provider-ibm/releases/download/v1.2.0/linux_amd64.zip"
ARG ansiblemodule="https://github.com/IBM-Cloud/ansible-collection-ibm.git"

# Install standard package
RUN apt update && \
  apt install -y groff-base jq tree vim

# Install Ansible
RUN pip install --upgrade pip && \
  pip install ansible

ENV ANSIBLE_CONFIG=/ansible/ansible.cfg

# Install Terraform & IBM Cloud Plugin
RUN set -x && \
  mkdir -p ~/.terraform.d/plugins && \
  curl -Lo terraform.zip ${terraform} && \
  unzip terraform.zip -d /usr/local/bin && \
  cd ~/.terraform.d/plugins && \
  curl -Lo darwin_amd64.zip ${terraplugin} && \
  unzip darwin_amd64.zip

# Install IBM Cloud Ansible Collection
RUN set -x && \
  git clone ${ansiblemodule} && \
  cd ansible-collection-ibm && \
  cp modules/* /usr/local/lib/python3.6/site-packages/ansible/modules/. && \
  cp module_utils/* /usr/local/lib/python3.6/site-packages/ansible/module_utils/.
