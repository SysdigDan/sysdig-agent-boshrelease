#!/bin/bash

set -e

TMP_DIR=tmp/
AGENT_VERSION=12.9.1

mkdir -p $TMP_DIR
cd $TMP_DIR

# Download Sysdig Agent and Probe
if [ "$1" != "--skip-download" ]; then
  wget -q -O ./draios-${AGENT_VERSION}-x86_64-agent.rpm https://s3.amazonaws.com/download.draios.com/stable/rpm/x86_64/draios-${AGENT_VERSION}-x86_64-agent.rpm
  wget -q -O ./draios-${AGENT_VERSION}-x86_64-agent.deb https://s3.amazonaws.com/download.draios.com/stable/deb/stable-amd64/draios-${AGENT_VERSION}-x86_64-agent.deb
  wget -q -O ./sysdigcloud-probe-${AGENT_VERSION}-x86_64-4.15.0-191-generic.ko https://s3.amazonaws.com/download.draios.com/stable/sysdig-probe-binaries/sysdigcloud-probe-${AGENT_VERSION}-x86_64-4.15.0-191-generic-d8051e959d836ee23665f1d33702220a.ko
fi

# Fix permissions
sudo chown -R ubuntu:ubuntu ../${TMP_DIR}