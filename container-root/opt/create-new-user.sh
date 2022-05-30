#!/bin/bash

export NEW_USERNAME=$1
export NEW_USER_PASSWORD=$2

echo "Creating the user ${NEW_USERNAME}..."
useradd $NEW_USERNAME; echo $NEW_USER_PASSWORD | passwd $NEW_USERNAME --stdin

echo "Adding user to sudoers group 'wheel'..."
usermod -aG wheel $NEW_USERNAME

if [ $(which zsh) -eq 0 ]; then
  echo "Setting user shell to ZSH..."
  chsh --shell $(which zsh) $NEW_USERNAME
fi

echo "Setting user as default WSL user..."
echo "[user]" > /etc/wsl.conf
echo "default=$NEW_USERNAME" >> /etc/wsl.conf

mkdir -p /run/user/$(id -u $NEW_USERNAME)
chown ${NEW_USERNAME}:${NEW_USERNAME} /run/user/$(id -u $NEW_USERNAME)
usermod --add-subuids 200000-201000 --add-subgids 200000-201000 $NEW_USERNAME
