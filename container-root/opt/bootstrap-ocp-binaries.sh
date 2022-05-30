#!/bin/bash

if [ ! -f "/usr/local/bin/kubectl" ]; then
  echo "===== Installing kubectl and oc..."
  curl -sSL -o /tmp/oc-4.10.tar.gz https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest-4.10/openshift-client-linux.tar.gz
  tar -C /tmp -zxf /tmp/oc-4.10.tar.gz
  mv /tmp/oc /usr/local/bin/oc
  mv /tmp/kubectl /usr/local/bin/kubectl
  rm /tmp/oc*.tar.gz

  chmod a+rx /usr/local/bin/kubectl
  chmod a+rx /usr/local/bin/oc

  echo 'if [ -n "$BASH" ]; then' > /etc/profile.d/kubectl_completion.sh
  echo "  source <(/usr/local/bin/kubectl completion bash)" >> /etc/profile.d/kubectl_completion.sh
  echo "fi" >> /etc/profile.d/kubectl_completion.sh
  echo "source <(/usr/local/bin/kubectl completion zsh)" >> /etc/profile.d/kubectl_completion.zsh
  chmod a+rx /etc/profile.d/kubectl_completion.sh
  chmod a+rx /etc/profile.d/kubectl_completion.zsh

  echo 'if [ -n "$BASH" ]; then' > /etc/profile.d/oc_completion.sh
  echo "  source <(/usr/local/bin/oc completion bash)" >> /etc/profile.d/oc_completion.sh
  echo "fi" >> /etc/profile.d/oc_completion.sh
  echo "source <(/usr/local/bin/oc completion zsh)" > /etc/profile.d/oc_completion.zsh
  echo "alias oc='oc --insecure-skip-tls-verify'" >> /etc/profile.d/oc_completion.sh
  echo "alias oc='oc --insecure-skip-tls-verify'" >> /etc/profile.d/oc_completion.zsh
  chmod a+rx /etc/profile.d/oc_completion.sh
  chmod a+rx /etc/profile.d/oc_completion.zsh
fi

if [ ! -f "/usr/local/bin/odo" ]; then
  echo "===== Installing odo..."
  curl -sSL -o /usr/local/bin/odo https://developers.redhat.com/content-gateway/rest/mirror/pub/openshift-v4/clients/odo/v2.5.1/odo-linux-amd64
  chmod a+rx /usr/local/bin/odo
fi