[![Build Status](https://travis-ci.org/bigfix/boxes.svg?branch=master)](https://travis-ci.org/bigfix/boxes)

A collection of packer templates to create vagrant boxes for building and installing IBM Endpoint Manager

# Usage
## Prerequisites
- [packer-0.7.x](http://www.packer.io/downloads.html)
- [vagrant-1.7.x](http://www.vagrantup.com/downloads.html)
- Virtualization
	- [VirtualBox-4.3.x](https://www.virtualbox.org/wiki/Downloads)
	- [VMWare ESXi-5.5.x](http://www.vmware.com/products/esxi-and-esx/)

### Configuration
#### packer Template
The nomenclature of the packer templates is:

```
{os}{version}{architecture}-{application}
```

Depending on the desired box, there may be additional prerequisites.

The templates are created with hardcoded values for internal usage. However, the scripts have been organized for easy configuration.

Each template has variables at the top for configuring the name and iso. And as previously mentioned, a template may have provisioner scripts that require specific applications. These scripts will be located in the [`bigfix/`](bigfix/) folder.

#### Vagrantfile
The Vagrantfiles are designed to be as atomic as possible. Specifically, the specifications of the box should be encapsulated in the file. If a box requires configuration, it can be be specified via editing the top of the Vagrantfile and/or providing an environment variable.

## bigfix
This section documents how this repository can be used within the [bigfix](http://platdev.sfolab.ibm.com/) organization.

### Example
The following examples start a box with the 9.2.3.68 IBM Endpoint Manager Root Server on a Red Hat Enterprise Linux 7.0 x86_64 and DB2 10.5 FP3 system.

This example installs the 9.2.3.68 IBM Endpoint Manager Root Server on start up.

```bash
$ git clone https://github.com/bigfix/boxes.git
$ cd vagrant/server/redhat
$ BIGFIX_VERSION="9.2.3.68" vagrant up
```

This example starts a box with the 9.2.6.94 IBM Endpoint Manager Root Server already installed:

```bash
$ git clone https://github.com/bigfix/boxes.git
$ cd vagrant/server/redhat/9.2
$ vagrant up
```

#### [ohana](https://youtu.be/-U0xGBNl2fE)
The Vagrantfiles at [`vagrant/server`](vagrant/server) and [`vagrant/ready`](vagrant/ready) have an `OHANA` environment variable option to add platforms to a `BIGFIX_ROOT` environment. This configuration is disabled by default and can be enabled by:

```bash
$ OHANA=1 vagrant up
```

#### Example
The following example creates a 9.2.6.94 IBM Endpoint Manager environment with:

1. Root Server on a Red Hat Enterprise Linux 7.0 x86_64 and DB2 10.5 FP3 system.

        $ git clone https://github.com/bigfix/boxes.git
        $ cd vagrant/server/redhat/9.2
        $ OHANA=1 vagrant up

2. Relay on a [CentOS 6.6 x86_64](https://atlas.hashicorp.com/chef/boxes/centos-6.6) system.

        $ cd vagrant/ready/centos
        $ OHANA=1 vagrant up relay

3. Agent on a [Ubuntu 14.04 x86_64](https://atlas.hashicorp.com/ubuntu/boxes/trusty64) system.

        $ cd vagrant/ready/ubuntu
        $ OHANA=1 vagrant up agent

# Support
Any issues or questions regarding this software should be filed via [GitHub issues](https://github.com/bigfix/boxes/issues).
