#!/bin/bash

set -x

if [ ! -f "/usr/local/bin/composer" ]; then
  echo "===== Installing Composer for PHP..."

  if [ ! -z "$HTTP_PROXY" ]; then
    php -r "\$opts = array('http' => array('proxy' => '$HTTP_PROXY')); \$context = stream_context_create(\$opt); copy('https://getcomposer.org/installer', 'composer-setup.php', \$context);"
  else
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
  fi

  php composer-setup.php
  php -r "unlink('composer-setup.php');"
  mv composer.phar /usr/local/bin/composer
  
  echo 'export PATH=$HOME/.composer/vendor/bin:$PATH' > /etc/profile.d/composer_bin.sh
  chmod a+rx /etc/profile.d/composer_bin.sh
  cp /etc/profile.d/composer_bin.sh /etc/profile.d/composer_bin.zsh
fi
