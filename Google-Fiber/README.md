# Google Fiber (IPv4 + IPv6) EdgeRouter Example config.boot Files

These files are example `config.boot` configuration files that can be be loaded on a factory-default Ubiquiti EdgeRouter
Lite (ERLite-3) or EdgeRouter POE (ERPOE-5) to enable dual-stack IPv4 & IPv6 networking on Google Fiber and replace the Google Fiber Network Box.

- `config.boot.erl` - Google Fiber configuration file for EdgeRouter Lite
- `config.boot.poe` - Google Fiber configuration file for EdgeRouter POE

# Configuration Options
The default port/interface settings for each version of the example Google Fiber `config.boot` files are:

###Google Fiber config.boot.erl####
- `eth0` = LAN
- `eth1` = WAN (Google Fiber Jack)
- `eth2` = Local Config Port

###Google Fiber config.boot.poe####
- `eth0` = Local Config Port
- `eth1` = WAN (Google Fiber Jack)
- `eth2`, `eth3`, `eth4` = LAN (combined as `switch0`)

You can edit the interfaces based on your specific needs.

# Usage
A full walk-thru for using these files is located here:

https://www.stevejenkins.com/blog/2015/11/replace-your-google-fiber-network-box-with-a-ubiquiti-edgerouter-lite/

Copy the raw contents of the appropriate `config.boot` file into your local clipboard.
Then create a blank `config.boot` file in `/home/ubnt` with:

    $ sudo vi /home/ubnt/config.boot

Once inside the vi editor, turn off the auto-indenting feature before you paste by typing

    :set noai

and pressing `ENTER`. If you’re not familiar with vi, make sure you type the `:` whenever they’re shown in this guide.

Now enter “insert” mode by pressing lowercase `i` (you don’t need `ENTER` after the `i` command).

Paste the copied raw `config.boot` file from your local system’s clipboard using your terminal client’s
Paste menu item or keyboard shortcut (usually `CTRL-V` on PC, `Command-V` on Mac, etc.). Now write and quit
the file by typing:

    :wq

and then `ENTER`.

Now you’re ready to copy your new `config.boot` file over the EdgeRouter’s default `config.boot` file with:

    $ sudo cp /home/ubnt/config.boot /config/config.boot

You can apply the new `config.boot` file by rebooting the router with the `reboot` command, or with:

    load
    commit
    save
    
# Google Fiber IPv6 Considerations
Based on the most recent IPv6 information from Google, residential customers should be requesting IPv6 addressing
with a prefix length of `/56` (which is what is used in these examples).

If you edit the IPv6 settings in your `config.boot` and want to apply them immediately, do:

    release dhcpv6-pd interface eth0
    delete dhcpv6-pd duid 
    renew dhcpv6-pd interface eth0

# Support
Support for using these files is on this thread in the UBNT EdgeMax forums:

https://community.ubnt.com/t5/EdgeMAX/Updated-Google-Fiber-EdgeRouter-Lite-PoE-IPv4-amp-IPv6-config/m-p/1790440
