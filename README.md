# Ubiquiti EdgeRouter / EdgeMax Example config.boot Files
This repo contains a collection of example **config.boot** files which you can use as a starting point
for configuring your UBNT EdgeRouter for IPv4 and IPv6 on a number of networks, including:

* Google Fiber
* Comcast

# Usage
More detailed usage instructions coming soon. Basically, get the **config.boot** file on your EdgeRouter
any way you can (copy and paste the contents if you have to), then load, commit, save, and reboot.

## IPv6 Configuration Changes
After making any changes to the IPv6 settings of your **config.boot**, you can either reboot to apply the changes or do:

    release dhcpv6-pd interface eth0
    delete dhcpv6-pd duid 
    renew dhcpv6-pd interface eth0

Change **eth0** as needed to match your configuration's WAN interface.
