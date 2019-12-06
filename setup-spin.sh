#!/bin/bash

# Create AWS credential and config file
if [ ! -d ~/.spin ]
then
    mkdir -p ~/.spin
fi

if [ -f ~/.spin/config ]
then
    rm -rf ~/.spin/config
fi

GATE_ENDPT=$(/usr/bin/kubectl get ing | grep gate | awk '{ print $3 }')

cat <<EOT >> ~/.spin/config
gate:
  endpoint: http://$GATE_ENDPT:8084
EOT
