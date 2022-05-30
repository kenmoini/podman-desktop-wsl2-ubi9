#!/bin/bash

if [ ! -f "/usr/local/bin/zsh" ]; then
  echo "===== Installing ZSH..."
  curl -sSL -o /tmp/zsh.tar.xz ftp://ftp.zsh.org/pub/old/zsh-5.8.1.tar.xz
  cd /tmp && tar xvf zsh.tar.xz
  rm zsh.tar.xz
  cd zsh-5.8.1
  ./configure
  make
  make install
  ln -s /usr/local/bin/zsh /bin/zsh
  echo "/bin/zsh" >> /etc/shells
  echo "/usr/local/bin/zsh" >> /etc/shells
fi