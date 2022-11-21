#!/bin/bash

RELEASE="sysdig-agent"
SYSDIG_AGENT_VERSION=12.9.1-1
RELEASE_DEV_VERSION=${SYSDIG_AGENT_VERSION}+dev.4

TMP_DIR=tmp/
mkdir -p ${TMP_DIR}

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WORKING_DIR="${DIR}/.."

mkdir -p ${WORKING_DIR}/blobstore

# if bosh isn't on the docker image, download it
if [ ! -f "/usr/local/bin/bosh" ]; then
  mkdir -p ${WORKING_DIR}/bin
  curl -sSL -o ${WORKING_DIR}/bin/bosh https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-2.0.48-linux-amd64
  chmod +x ${WORKING_DIR}/bin/bosh
  export PATH="${WORKING_DIR}/bin:${PATH}"
fi

# run the prepare script
./prepare
bosh sync-blobs

if [ "$1" = "--dev" ]; then
  # release a dev version of the agent
  bosh create-release --force --name ${RELEASE} --version=${RELEASE_DEV_VERSION} --tarball=tmp/sysdig-agent-release-${RELEASE_DEV_VERSION}.tgz

  # upload to archive storage
  scp -P 2222 tmp/sysdig-agent-release-${RELEASE_DEV_VERSION}.tgz admin@192.168.101.101://volume1/web
elif [ "$1" = "--release" ]; then
  # release a dev version of the agent to ensure the cache is warm
  # (it's better to fail here than to fail when really attempting to release it)
  bosh create-release --force --name ${RELEASE} --version=${RELEASE_DEV_VERSION}

  # finally, release the agent
  bosh create-release --force --final --name ${RELEASE} --version=${SYSDIG_AGENT_VERSION} --tarball=tmp/sysdig-agent-release-${SYSDIG_AGENT_VERSION}.tgz
  bosh upload-blobs

  # config git
  git config --global user.email "daniel.moloney@sysdig.com"
  git config --global user.name "Daniel Moloney"
  git remote set-url origin git@github.com:SysdigDan/sysdig-agent-release.git

  # git commit it and then push it to the repo
  git add .
  git commit -m "Release Sysdig Agent ${SYSDIG_AGENT_VERSION}"
  git push
fi
