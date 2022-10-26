set -e

TMP_FILES=./tmp
AGENT_VERSION=12.9.0

mkdir -p $files_dir
cd $TMP_FILES

if [ "$1" != "--skip-download" ]; then
  # Download Sysdig Agent
  apt-get -qq install apt-transport-https
  curl -s https://download.sysdig.com/DRAIOS-GPG-KEY.public | apt-key add -
	curl -s -o /etc/apt/sources.list.d/draios.list https://download.sysdig.com/stable/deb/draios.list
  apt-get -qq update && apt-get -qq install --download-only -o Dir::Cache="/tmp/" draios-agent=${AGENT_VERSION}
fi