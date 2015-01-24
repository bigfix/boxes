# Usage
## Prerequisites
- [vagrant-1.7.x](http://www.vagrantup.com/downloads.html)
- [VirtualBox-4.3.x](https://www.virtualbox.org/wiki/Downloads)
- [rsync](https://rsync.samba.org/download.html)
- [p4](http://www.perforce.com/downloads)
 - `LineEnd: share`

## Compile
### Example
The following example builds a Ubuntu x86_64 agent and runs unit tests.

```bash
git clone git@github.com:bigfix/boxes.git
cd vagrant/build/ubuntu
vagrant up
vagrant ssh --command "cd /vagrant/BES/ProjectFiles/Unix && make package && make unittests"
```
