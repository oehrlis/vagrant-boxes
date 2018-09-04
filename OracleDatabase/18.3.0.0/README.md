# oracle-18c-vagrant
A vagrant box that provisions Oracle Database automatically, using Vagrant, an Oracle Linux 7 box and a shell script.

## Prerequisites
1. Install [Oracle VM VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. Install [Vagrant](https://vagrantup.com/)

## Getting started
1. Clone this repository `git clone https://github.com/oehrlis/vagrant-boxes`
2. Change into the desired version folder
3. Download the installation zip files from OTN into this folder - first time only:
[http://www.oracle.com/technetwork/database/enterprise-edition/downloads/index.html](http://www.oracle.com/technetwork/database/enterprise-edition/downloads/index.html)
4. Run `vagrant up`
   1. The first time you run this it will provision everything and may take a while. Ensure you have (a good) internet connection as the scripts will update the virtual box to the latest via `yum`.
   2. The Vagrant file allows for customization, if desired (see [Customization](#customization))
5. Connect to the database.
6. You can shut down the box via the usual `vagrant halt` and the start it up again via `vagrant up`.

## Connecting to Oracle
* Hostname: `localhost`
* Port: `1521`
* SID: `TDB183A`
* OEM port: `5500`
* All passwords are auto-generated and printed on install

## Resetting password
You can reset the password of the Oracle database accounts by executing `/home/oracle/setPassword.sh <Your new password>`.

## Other info

* If you need to, you can connect to the machine via `vagrant ssh`.
* You can `sudo su - oracle` to switch to the oracle user.
* The Oracle installation path is `/u00/app/oracle/` by default.
* On the guest OS, the directory `/vagrant` is a shared folder and maps to wherever you have this file checked out.

### Customization
You can customize your Oracle environment by amending the environment variables in the `Vagrantfile` file.
The following can be customized:
* `ORACLE_BASE`: `/u00/app/oracle/`
* `ORACLE_HOME`: `/u00/app/oracle/product/18.3.0.0'`
* `ORACLE_SID`: `TDB183A`
* `ORACLE_CHARACTERSET`: `AL32UTF8`
* `ORACLE_EDITION`: `EE` | `SE2`
* `ORACLE_PWD`: `auto generated`


## License
oehrlis/vagrant-boxes is licensed under the GNU General Public License v3.0. You may obtain a copy of the License at <https://www.gnu.org/licenses/gpl.html>.

To download and run Oracle Database Server Enterprise Edition, Oracle Unified Directory or any other Oracle product, regardless whether inside or outside a Vagrant box respectively VM, you must download the binaries from the Oracle website and accept the license indicated at that page. See [OTN Developer License Terms](http://www.oracle.com/technetwork/licenses/standard-license-152015.html) and [Oracle Database Licensing Information User Manual](https://docs.oracle.com/database/122/DBLIC/Licensing-Information.htm#DBLIC-GUID-B6113390-9586-46D7-9008-DCC9EDA45AB4)
