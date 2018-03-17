# Cobbler

This puppet module deploys non managed DHCP Cobbler with Cobbler WebUI and custom kickstart template.

## Getting Started
Example system configuration steps for cobbler and external ISC DHCP server.

#### Add CentOS 7 distro

1. Download CentOS7 Minimal `.iso` file on the server.
2. Mount iso:  
`mount -t iso9660 -o loop,ro /path/to/centos7.iso /mnt`
3. Import distro using:  
`cobbler import --name=centos7 --arch=x86_64 --path=/mnt`  
This will automatically create default profile for this distro.
4. List distros:  
`cobbler distro list`  
List profiles:  
`cobbler profile list`

#### Add Cobbler system (CLI example, minimal requirements)
This module supports gPXE/iPXE http/tftp booting and chainloading:
1. `cobbler system add --name=webserver01 --profile=centos7-x86_64 --hostname=webserver01 --enable-gpxe=1` \# basic info
2. `cobbler system edit --name=webserver01 --interface=eth0 --mac=00:11:22:AA:BB:CC` \# network configuration
3. `cobbler sync`
4. `cobbler system report --name=webserver01` \# get info about the system

#### External DHCP setup guide
Since this module does not support embedded ISC DHCP server management it is required to make additional configuration changes in external DHCP server. Please add following options and parameters in `/etc/dhcp/dhcpd.conf` global configuration section:
```
### Global Configuration
allow booting;
allow bootp;
set vendorclass = option vendor-class-identifier;
option pxe-system-type code 93 = unsigned integer 16;
```
Create new group for cobbler clients with the following options:
```
### Cobbler Group Declaration
group {
  # Cobbler IP
  next-server                10.0.0.5;
  # Detect vendor class and choose the right bootfile for pxe-system-type
  class "pxeclients" {
    match if substring (option vendor-class-identifier, 0, 9) = "PXEClient";
    if option pxe-system-type = 00:02 {
      filename "ia64/elilo.efi";
    } else if option pxe-system-type = 00:06 {
      filename "grub/grub-x86.efi";
    } else if option pxe-system-type = 00:07 {
      filename "grub/grub-x86_64.efi";
    } else if option pxe-system-type = 00:09 {
      filename "grub/grub-x86_64.efi";
    } else {
      filename "pxelinux.0";
    }
  }
}
```
By default iPXE is enabled.  So...
For every created system in cobbler add host declaration like this example <b>in the created cobbler clients group</b>:  
```
host webserver01 {
  hardware ethernet 00:11:22:AA:BB:CC;
  fixed-address 10.0.0.10;

  if exists user-class and option user-class = "gPXE" {
    filename "http://10.0.0.5:80/cblr/svc/op/gpxe/system/webserver01";
  } else if exists user-class and option user-class = "iPXE" {
    filename "http://10.0.0.5:80/cblr/svc/op/gpxe/system/webserver01";
  } else {
    filename "undionly.kpxe";
  }
}
```
<b>Note!</b> It is recommended to name the host declaration the same name as cobbler system (`--name`) for easy reading.

### Cobbler WebUI

1. Using browser:  
URL: `https://<cobbler_ip>/cobbler_web`  
User: `cobbler`  
Password: `cobbler`  

2. To generate new password for user, issue command below and change `$cobbler_web_info` parameter:  
`htdigest -c /tmp/random "Cobbler" cobbler && cat /tmp/random && rm -f /tmp/random`


### Kickstart
Default kickstart for profiles/systems:  
`/var/lib/cobbler/kickstarts/custom.ks`  
Default kickstart root password:  
`cobbler`  
##### Generate new SHA-512 hashed shadow password:
- `python -c 'import crypt; print crypt.crypt("password", "$6$random_salt")'`
- change `$ks_root_passwd` parameter.
