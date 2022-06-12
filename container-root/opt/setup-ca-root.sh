#!/bin/bash

# Check to see if running in Tekton
if [ -f "/tekton-custom-certs/ca-bundle.crt" ]; then
  echo "Found /tekton-custom-certs/ca-bundle.crt, running in Tekton"
  export SSL_CERT_FILE="/tekton-custom-certs/ca-bundle.crt"
fi

