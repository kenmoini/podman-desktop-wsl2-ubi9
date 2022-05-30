#!/bin/bash

echo 'export GOPATH=$HOME/go' > /etc/profile.d/golang_setup.sh

echo 'export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin' >> /etc/profile.d/golang_setup.sh

chmod a+rx /etc/profile.d/golang_setup.sh

cp /etc/profile.d/golang_setup.sh /etc/profile.d/golang_setup.zsh
