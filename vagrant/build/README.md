# Usage
## Prerequisites
- [vagrant-1.7.x](http://www.vagrantup.com/downloads.html)
- [VirtualBox-4.3.x](https://www.virtualbox.org/wiki/Downloads)
- [rsync](https://rsync.samba.org/download.html)
- [p4](http://www.perforce.com/downloads)
 - `LineEnd: share`

## Compile
All build machines are configured with vagrant's [multi-machine functionality](https://docs.vagrantup.com/v2/multi-machine/index.html). The available machine configurations are:

- dev (default)
- swarm

### dev
#### Example
The following example builds an IBM Endpoint Manager Ubuntu x86_64 Agent and runs unit tests.

```bash
git clone git@github.com:bigfix/boxes.git
ln -s boxes/vagrant/build/ubuntu/Vagrantfile /depot/Main/Vagrantfile
cd /depot/Main/Vagrantfile
vagrant up
vagrant ssh --command "cd /vagrant/BES/ProjectFiles/Unix && make package && make unittests"
```

The following example builds an IBM Endpoint Manager Red Hat x86_64 Root Server and runs unit tests.

```bash
git clone git@github.com:bigfix/boxes.git
ln -s boxes/vagrant/build/redhat/Vagrantfile /depot/Main/Vagrantfile
cd /depot/Main/Vagrantfile
vagrant up
vagrant ssh --command "cd /vagrant/BES/ProjectFiles/Unix && make package_server && make unittests"
```
