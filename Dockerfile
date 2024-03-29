FROM registry.access.redhat.com/ubi9/ubi-init:9.0.0-16

ENV UPDATE_SYSTEM="true"
ENV INSTALL_HELPFUL_TOOLS="true"
ENV INSTALL_DEV_TOOLS="true"
ENV INSTALL_PYTHON="true"
ENV INSTALL_GOLANG="true"
ENV INSTALL_NODEJS="true"
ENV INSTALL_ANSIBLE="true"
ENV INSTALL_PHP="true"
ENV INSTALL_PODMAN="true"

COPY container-root/ /

## Rebuild system trusted root CA store
RUN update-ca-trust

## Set Proxy Configuration environmental variables
#ENV http_proxy http://192.168.51.1:3128
#ENV https_proxy http://192.168.51.1:3128
#ENV no_proxy localhost,127.0.0.1
#ENV HTTP_PROXY http://192.168.51.1:3128
#ENV HTTPS_PROXY http://192.168.51.1:3128
#ENV NO_PROXY localhost,127.0.0.1

## Disable Red Hat Repos
#RUN /opt/disable-rhel-repos.sh

## Install language packs & cerficiates
RUN dnf install -y langpacks-en glibc-langpack-en ca-certificates \
  --disablerepo='*' --enablerepo="ubi-9-baseos" --enablerepo="ubi-9-baseos-debug" --enablerepo="ubi-9-baseos-source" --enablerepo="ubi-9-appstream" --enablerepo="ubi-9-appstream-debug" --enablerepo="ubi-9-appstream-source" --enablerepo="ubi-9-codeready-builder" --enablerepo="ubi-9-codeready-builder-debug" --enablerepo="ubi-9-codeready-builder-source" \
  && dnf clean all \
  && rm -rf /var/cache/yum

RUN if [ "$UPDATE_SYSTEM" = "true" ]; then \
    dnf update -y \
    --disablerepo='*' --enablerepo="ubi-9-baseos" --enablerepo="ubi-9-baseos-debug" --enablerepo="ubi-9-baseos-source" --enablerepo="ubi-9-appstream" --enablerepo="ubi-9-appstream-debug" --enablerepo="ubi-9-appstream-source" --enablerepo="ubi-9-codeready-builder" --enablerepo="ubi-9-codeready-builder-debug" --enablerepo="ubi-9-codeready-builder-source" \
    && dnf clean all \
    && rm -rf /var/cache/yum; \
  fi

## Install basic useful packages
RUN if [ "$INSTALL_HELPFUL_TOOLS" = "true" ]; then \
    dnf install -y wget sudo ncurses dnf-plugins-core dnf-utils passwd findutils nano openssl openssh-clients procps-ng git bash-completion jq util-linux-user cracklib-dicts \
    --disablerepo='*' --enablerepo="ubi-9-baseos" --enablerepo="ubi-9-baseos-debug" --enablerepo="ubi-9-baseos-source" --enablerepo="ubi-9-appstream" --enablerepo="ubi-9-appstream-debug" --enablerepo="ubi-9-appstream-source" --enablerepo="ubi-9-codeready-builder" --enablerepo="ubi-9-codeready-builder-debug" --enablerepo="ubi-9-codeready-builder-source" \
    && dnf clean all \
    && rm -rf /var/cache/yum; \
  fi

## Install development tools
RUN if [ "$INSTALL_DEV_TOOLS" = "true" ]; then \
    dnf install -y autoconf automake gcc gcc-c++ gdb glibc-devel libtool make pkgconf pkgconf-m4 pkgconf-pkg-config redhat-rpm-config rpm-build ncurses-devel \
    --disablerepo='*' --enablerepo="ubi-9-baseos" --enablerepo="ubi-9-baseos-debug" --enablerepo="ubi-9-baseos-source" --enablerepo="ubi-9-appstream" --enablerepo="ubi-9-appstream-debug" --enablerepo="ubi-9-appstream-source" --enablerepo="ubi-9-codeready-builder" --enablerepo="ubi-9-codeready-builder-debug" --enablerepo="ubi-9-codeready-builder-source" \
    && dnf clean all \
    && rm -rf /var/cache/yum; \
  fi

## Install Python
RUN if [ "$INSTALL_PYTHON" = "true" ]; then \
    dnf install -y python3-pip python3 \
    --disablerepo='*' --enablerepo="ubi-9-baseos" --enablerepo="ubi-9-baseos-debug" --enablerepo="ubi-9-baseos-source" --enablerepo="ubi-9-appstream" --enablerepo="ubi-9-appstream-debug" --enablerepo="ubi-9-appstream-source" --enablerepo="ubi-9-codeready-builder" --enablerepo="ubi-9-codeready-builder-debug" --enablerepo="ubi-9-codeready-builder-source" \
    && dnf clean all \
    && rm -rf /var/cache/yum; \
  fi

## Install Golang
RUN if [ "$INSTALL_GOLANG" = "true" ]; then \
    dnf install -y golang \
    --disablerepo='*' --enablerepo="ubi-9-baseos" --enablerepo="ubi-9-baseos-debug" --enablerepo="ubi-9-baseos-source" --enablerepo="ubi-9-appstream" --enablerepo="ubi-9-appstream-debug" --enablerepo="ubi-9-appstream-source" --enablerepo="ubi-9-codeready-builder" --enablerepo="ubi-9-codeready-builder-debug" --enablerepo="ubi-9-codeready-builder-source" \
    && /opt/bootstrap-golang.sh \
    && dnf clean all \
    && rm -rf /var/cache/yum; \
  fi

## Install Ansible
RUN if [ "$INSTALL_ANSIBLE" = "true" ]; then \
    python3 -m pip install ansible-base argcomplete \
    && /opt/bootstrap-ansible.sh; \
  fi

## Install PHP
RUN if [ "$INSTALL_PHP" = "true" ]; then \
    dnf install -y php php-bcmath php-cli php-devel php-gd php-intl php-json php-mbstring php-pdo php-pear php-process php-xml \
    --disablerepo='*' --enablerepo="ubi-9-baseos" --enablerepo="ubi-9-baseos-debug" --enablerepo="ubi-9-baseos-source" --enablerepo="ubi-9-appstream" --enablerepo="ubi-9-appstream-debug" --enablerepo="ubi-9-appstream-source" --enablerepo="ubi-9-codeready-builder" --enablerepo="ubi-9-codeready-builder-debug" --enablerepo="ubi-9-codeready-builder-source" \
    && /opt/bootstrap-php.sh \
    && dnf clean all \
    && rm -rf /var/cache/yum; \
  fi

## Install NodeJS
RUN if [ "$INSTALL_NODEJS" = "true" ]; then \
    dnf install -y nodejs npm \
    --disablerepo='*' --enablerepo="ubi-9-baseos" --enablerepo="ubi-9-baseos-debug" --enablerepo="ubi-9-baseos-source" --enablerepo="ubi-9-appstream" --enablerepo="ubi-9-appstream-debug" --enablerepo="ubi-9-appstream-source" --enablerepo="ubi-9-codeready-builder" --enablerepo="ubi-9-codeready-builder-debug" --enablerepo="ubi-9-codeready-builder-source" \
    && dnf clean all \
    && rm -rf /var/cache/yum; \
  fi

## Install Podman
RUN if [ "$INSTALL_PODMAN" = "true" ]; then \
    dnf install podman skopeo buildah crun slirp4netns fuse-overlayfs containernetworking-plugins iputils iproute -y \
    --disablerepo='*' --enablerepo="ubi-9-baseos" --enablerepo="ubi-9-baseos-debug" --enablerepo="ubi-9-baseos-source" --enablerepo="ubi-9-appstream" --enablerepo="ubi-9-appstream-debug" --enablerepo="ubi-9-appstream-source" --enablerepo="ubi-9-codeready-builder" --enablerepo="ubi-9-codeready-builder-debug" --enablerepo="ubi-9-codeready-builder-source" \
    && dnf clean all \
    && rm -rf /var/cache/yum \
    && chmod 4755 /usr/bin/newgidmap \
    && chmod 4755 /usr/bin/newuidmap \
    && dnf reinstall -yq shadow-utils \
    --disablerepo='*' --enablerepo="ubi-9-baseos" --enablerepo="ubi-9-baseos-debug" --enablerepo="ubi-9-baseos-source" --enablerepo="ubi-9-appstream" --enablerepo="ubi-9-appstream-debug" --enablerepo="ubi-9-appstream-source" --enablerepo="ubi-9-codeready-builder" --enablerepo="ubi-9-codeready-builder-debug" --enablerepo="ubi-9-codeready-builder-source" \
    && dnf clean all \
    && rm -rf /var/cache/yum; \
  fi

## Create new user
RUN /opt/create-new-user.sh 'wsluser' 'Passw0rd123!'
