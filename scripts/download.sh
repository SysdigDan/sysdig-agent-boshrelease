#!/bin/bash

set -e

TMP_DIR=tmp
AGENT_VERSION=12.9.0

mkdir -p $TMP_DIR
cd $TMP_DIR

# Download Sysdig Agent
if [ "$1" != "--skip-download" ]; then
  apt-get -qq install apt-transport-https
  curl -s https://download.sysdig.com/DRAIOS-GPG-KEY.public | apt-key add -
  curl -s -o /etc/apt/sources.list.d/draios.list https://download.sysdig.com/stable/deb/draios.list
  apt-get -qq update && apt-get -qq install --download-only draios-agent=${AGENT_VERSION}
  cp /var/cache/apt/archives/draios-agent_${AGENT_VERSION}_amd64.deb .
fi

# Download Sysdig Agent Probe
if [ "$1" != "--skip-download" ]; then
  wget -q -O ./sysdigcloud-probe-${AGENT_VERSION}-x86_64-4.15.0-191-generic.ko https://s3.amazonaws.com/download.draios.com/stable/sysdig-probe-binaries/sysdigcloud-probe-${AGENT_VERSION}-x86_64-4.15.0-191-generic-d8051e959d836ee23665f1d33702220a.ko
fi