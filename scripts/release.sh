#!/bin/bash

AGENT_VERSION=12.9.0
RELEASE_DEV_VERSION=1+dev.21

bosh add-blob scripts/draios-agent_${AGENT_VERSION}_amd64.deb sysdig-agent/draios-agent_${AGENT_VERSION}_amd64.deb
bosh add-blob scripts/sysdigcloud-probe-${AGENT_VERSION}-x86_64-4.15.0-191-generic.ko sysdig-agent/sysdigcloud-probe-${AGENT_VERSION}-x86_64-4.15.0-191-generic.ko

bosh create-release --force --name "sysdig-agent" --version=${RELEASE_DEV_VERSION=1+dev.21} --tarball=/tmp/sysdig-agent-release-${RELEASE_DEV_VERSION=1+dev.21}.tgz
scp -P 2222 /tmp/sysdig-agent-release-${RELEASE_DEV_VERSION=1+dev.21}.tgz admin@192.168.101.101://volume1/web
