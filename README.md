[![Build Status](https://travis-ci.org/bigfix/boxes.svg?branch=master)](https://travis-ci.org/bigfix/boxes)

A collection of packer templates to create vagrant boxes for building and installing IBM Endpoint Manager

# Usage
## Prerequisites
- [packer-0.6.x](http://www.packer.io/downloads.html)
- [vagrant-1.6.x](http://www.vagrantup.com/downloads.html)
- [VirtualBox-4.3.x](https://www.virtualbox.org/wiki/Downloads)

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

## Example
Tested on `stitch` a Windows 7 environment:
- packer-0.6.0
- vagrant-1.6.3
- VirtualBox-4.3.8
- [git-bash](http://git-scm.com/download/win)-1.8.4

The following examples create a box with the 9.1.1117.0 IBM Endpoint Manager Root Server. 

### -db2
This example uses the [`packer/redhat65x64-db2.json`](redhat65x64-db2.json) template.

First, it creates a Red Hat Enterprise Linux 6.5 x86_64 base box with DB2 10.5 FP2. Then, it provisions the base with the Root Server. The iso, application, and license are hosted on an internal web server.

On `stitch`:

```bash
$ git clone git@github.com:bigfix/boxes.git
$ cd boxes/packer
$ packer build redhat65x64-db2.json
$ cd -
$ vagrant box add builds/virtualbox/redhat65x64-db2.box --name bigfix/redhat65x64-db2
$ cd vagrant/server/redhat
$ BIGFIX_VERSION="9.1.1117.0" vagrant up
```

### -server
This example uses the [`packer/redhat65x64-server.json`](redhat65x64-db2.json) template.

Unlike [-db2](#-db2), this example creates a base with the Root Server already installed.

On `stitch`:

```bash
$ git clone git@github.com:bigfix/boxes.git
$ cd boxes/packer
$ BIGFIX_VERSION="9.1.1117.0" packer build redhat65x64-server.json
$ cd -
$ vagrant box add builds/virtualbox/redhat65x64-server.box --name bigfix/redhat65x64-server91patch3
$ cd vagrant/server/redhat/latest
$ vagrant up
```

# Support
Any issues or questions regarding this software should be filed via [GitHub issues](https://github.com/bigfix/boxes/issues).
