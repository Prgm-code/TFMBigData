# TFMBigData
# TFMBigData

This repository contains scripts and configurations for the deployment of a Big Data environment.

## Files

### `configs`

This directory contains configuration files necessary for the deployment of the Big Data environment.

### `base-instalation.sh`

This script performs the base installation of the Big Data environment.

### `copy-config.sh`

This script is responsible for copying the necessary configuration files to their respective locations.

### `ntp-config.sh`

This script performs the necessary Network Time Protocol (NTP) configuration to synchronize times across all machines in the Big Data environment.

### `ssh-setup.sh`

This script sets up the necessary SSH configuration for communication between machines in the Big Data environment.

### `variables-entorno.sh`

This script sets environment variables necessary for the correct operation of the Big Data environment.

### `jupyterhub-instalation.sh`

This script is reponsable to install and config a Jupyterhub Service

## Usage

To deploy the Big Data environment, follow these steps:

1. Clone this repository on your local machine or server.
2. Run the `base-instalation.sh` script.
3. Run the `copy-config.sh` script.
4. Run the `ntp-config.sh` script.
5. Run the `ssh-setup.sh` script.
6. Run the `variables-entorno.sh` script.

## Languages Used

- Shell (69.9%)
- Batchfile (26.0%)
- XSLT (4.1%)


## License

This project is open source and is available under the terms of the [MIT license](https://opensource.org/licenses/MIT).
