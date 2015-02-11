# Usage
## Prerequisites
- [packer-0.7.x](http://www.packer.io/downloads.html)
- [vagrant-1.7.x](http://www.vagrantup.com/downloads.html)
- Virtualization
	- [VirtualBox-4.3.x](https://www.virtualbox.org/wiki/Downloads)
	- [VMWare ESXi-5.5.x](http://www.vmware.com/products/esxi-and-esx/)

## Build
This section documents how [bigfix/boxes](https://github.com/bigfix/boxes) can be simulated in an external environment.

### virtualbox-iso
#### -db2
This example uses the [`redhat65x64-db2.json`](redhat65x64-db2.json) template.

This examples creates a box with the 9.2.1.48 IBM Endpoint Manager Root Server. First, it creates a Red Hat Enterprise Linux 6.5 x86_64 base box with DB2 10.5 FP3. Then, it provisions the base with the Root Server. The iso, application, and license are hosted on an internal web server.

On `stitch`:

```bash
$ git clone git@github.com:bigfix/boxes.git
$ cd boxes/packer
$ packer build redhat70x64-db2.json
$ cd -
$ vagrant box add builds/virtualbox/redhat70x64-db2.box --name bigfix/redhat70x64-db2
$ cd vagrant/ready/redhat
$ BIGFIX_VERSION="9.2.1.48" vagrant up
```

#### -server
This example uses the [`redhat70x64-server.json`](redhat70x64-db2.json) template.

Unlike [-db2](#-db2), this example creates a base with the Root Server already installed.

On `stitch`:

```bash
$ git clone git@github.com:bigfix/boxes.git
$ cd boxes/packer
$ BIGFIX_VERSION="9.2.1.48" packer build redhat70x64-server.json
```

### vmware-iso
#### Configuration
The following are changes that may be needed in a vanilla VMWare ESXi 5.5 server:

1. Enable the `SSH` service.
2. Enable the `SSH Client` and `SSH Server` firewall properties.
3. Run the following in the ESXi server:

        $ esxcli system settings advanced set -o /Net/GuestIPHack -i 1
4. Add the following contents to the ESXi server's `/etc/rc.local.d/local.sh`:

        cat > /etc/vmware/firewall/vnc.xml << EOF
        <ConfigRoot>
          <service>
            <id>vnc</id>
            <rule id='0000'>
              <direction>inbound</direction>
              <protocol>tcp</protocol>
              <porttype>dst</porttype>
              <port>
                <begin>5900</begin>
                <end>6000</end>
              </port>
            </rule>
            <enabled>true</enabled>
            <required>false</required>
          </service>
        </ConfigRoot>
        EOF
        
        cat > /etc/vmware/firewall/packer.xml << EOF
        <ConfigRoot>
          <service>
            <id>vnc</id>
            <rule id='0000'>
              <direction>inbound</direction>
              <protocol>tcp</protocol>
              <porttype>dst</porttype>
              <port>
                <begin>8000</begin>
                <end>9000</end>
              </port>
            </rule>
            <rule id='0001'>
              <direction>outbound</direction>
              <protocol>tcp</protocol>
              <porttype>dst</porttype>
              <port>
                <begin>8000</begin>
                <end>9000</end>
              </port>
            </rule>
            <enabled>true</enabled>
            <required>false</required>
          </service>
        </ConfigRoot>
        EOF
        
        esxcli network firewall refresh
5. Run the following in the ESXi Server:

        $ /etc/rc.local.d/local.sh

See [`jasonbernanek's explanation`](https://gist.github.com/jasonberanek/4670943) on why it is necessary persist the firewall rules via `/erc/rc.local.d/local.sh`. The rules are using packer's [default](https://www.packer.io/docs/builders/vmware-iso.html).

#### -build
This example uses the [`redhat65x64-build.json`](redhat65x64-build.json) template.

On `stitch`:

```bash
$ git clone git@github.com:bigfix/boxes.git
$ cd boxes/packer
$ REMOTE_HOST={host} REMOTE_DATASTORE={datastore} REMOTE_USERNAME={username} REMOTE_PASSWORD={password} packer build --only=vmware-iso redhat65x64-build.json
```

# Support
Any issues or questions regarding this software should be filed via [GitHub issues](https://github.com/bigfix/boxes/issues).
