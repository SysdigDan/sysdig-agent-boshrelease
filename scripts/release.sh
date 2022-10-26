#!/bin/bash

RELEASE="sysdig-agent"
SYSDIG_AGENT_VERSION=12.9.0
RELEASE_DEV_VERSION=${SYSDIG_AGENT_VERSION}+dev.1

# Add blobs to bosh
bosh add-blob tmp/draios-agent_${SYSDIG_AGENT_VERSION}_amd64.deb sysdig-agent/draios-agent_${SYSDIG_AGENT_VERSION}_amd64.deb
bosh add-blob tmp/sysdigcloud-probe-${SYSDIG_AGENT_VERSION}-x86_64-4.15.0-191-generic.ko sysdig-agent/sysdigcloud-probe-${SYSDIG_AGENT_VERSION}-x86_64-4.15.0-191-generic.ko

if [ "$1" = "--dev-only" ]; then
  bosh create-release --force --name ${RELEASE} --version=${RELEASE_DEV_VERSION} --tarball=tmp/sysdig-agent-release-${RELEASE_DEV_VERSION}.tgz
  scp -P 2222 tmp/sysdig-agent-release-${RELEASE_DEV_VERSION}.tgz admin@192.168.101.101://volume1/web
elif [ "$1" = "--release" ]; then
  # release a dev version of the agent to ensure the cache is warm
  bosh create-release --force --name ${RELEASE} --version=${RELEASE_DEV_VERSION} --tarball=tmp/sysdig-agent-release-${RELEASE_DEV_VERSION}.tgz
  # finally, release the agent
  bosh create-release --force --final --name ${RELEASE} --version=${SYSDIG_AGENT_VERSION} --tarball=tmp/sysdig-agent-release-${SYSDIG_AGENT_VERSION}.tgz
  bosh upload-blobs

  # config git
  git config --global user.email "daniel.moloney@sysdig.com"
  git config --global user.name "Daniel Moloney"
  git remote set-url origin git@github.com:SysdigDan/sysdig-agent-release.git

  # git commit it and then push it to the repo
  git add .
  git commit -m "releases sysdig agent ${SYSDIG_AGENT_VERSION}"
  git push
fi

