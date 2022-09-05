# Sysdig Agent BOSH Addon Release

## Repository Contents

This repository consists of the following file directories.

### jobs
Start and stop commands for the Sysdig Agent jobs (processes) running on the nodes. Currently, only 1 job named **sysdig-agent** in this repository.

The job 'sysdig-agent' is composed by the following things:
* **templates/bin/ctl.erb:** Provide start/stop Sysdig Agent process commands. 'start' command is based Sysdig Linux Agent Service. 'stop' will directly kill the process stored in the pid file.
* **spec:** Define the package dependencies and properties.
* **monit:** Provide monit way for BOSH to check the status of Sysdig Agent process.

### config
URLs and access credentials to the bosh blobstore for storing final releases. Currently, only contain configuration for local blob.

### src
Provide the utility script source code for the **common** package.

### manifests
Provide deployment manifest templates and related manifest generation scripts.

### releases
yml files containing the references to blobs for each package in a given release.

## Deploy Sysdig Agent Addon via BOSH

### Install BOSH CLI V2
[Download](https://bosh.io/docs/cli-v2.html#install) the binary for your platform and place it on your **PATH**.

### Download source code
```
# Clone repository
git clone git@github.com:sysdigdan/sysdig-agent-release.git
cd sysdig-agent-release
```

### Upload the Sysdig Agent Addon release

```
# Upload the created dev release:
bosh upload-release

# Confirm the release is uploaded.
bosh releases
```

### Update runtime-config

You can find the bosh runtime config file and deployment manifest samples in directory manifests.

Update your runtime-config manifest accroding to BOSH documentation (https://bosh.io/docs/runtime-config)

Ensure to include the minimum version required Sysdig configuration properties -
1. agent_key - The agent access key. You can retrieve this from Settings > Agent Installation in either Sysdig Monitor or Sysdig Secure.
2. collector_endpoint - The collector URL for Sysdig Monitor or Sysdig Secure. This value is region-dependent in SaaS and is auto-completed on the Get Started page in the UI.

Update your runtime-config:
```
bosh -n update-runtime-config manifests/sysdig-agent-1.0.0.yml
```

## Maintainers

- Daniel Moloney [dan at sysdig.com]

## Contributing

## License

Refer to [LICENSE](LICENSE.md).
