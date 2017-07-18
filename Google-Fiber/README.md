# Google Fiber (IPv4 + IPv6) EdgeRouter Example config.boot Files

These files are example `config.boot` configuration files that can be be loaded on a factory-default Ubiquiti EdgeRouter
Lite (ERLite-3), EdgeRouter X (ER-X), or EdgeRouter POE (ERPOE-5) to enable dual-stack IPv4 & IPv6 networking on Google Fiber and replace the Google Fiber Network Box.

- `config.boot.erl` - Google Fiber configuration file for EdgeRouter Lite
- `config.boot.erx` - Google Fiber configuration file for EdgeRouter X
- `config.boot.poe` - Google Fiber configuration file for EdgeRouter POE

# Port Settings
The default port/interface settings for each version of the example Google Fiber `config.boot` files are:

###Google Fiber config.boot.erl####
- `eth0` = WAN (Google Fiber Jack)
- `eth1` = Local Config Port
- `eth2` = LAN

###Google Fiber config.boot.erx####
- `eth0` = WAN (Google Fiber Jack)
- `eth1`, `eth2`, `eth3`, & `eth4` = LAN (combined as `switch0`)

###Google Fiber config.boot.poe####
- `eth0` = WAN (Google Fiber Jack) - 48v PoE ***on*** by default to power the jack.
- `eth1` = Local Config Port
- `eth2`, `eth3`, `eth4` = LAN (combined as `switch0`)

For all the files, `eth0` is always the **WAN** interface and `eth2` is always a valid **LAN** port to use during testing.

# Usage
A full walk-thru for using these files is located here:

https://www.stevejenkins.com/blog/2015/11/replace-your-google-fiber-network-box-with-a-ubiquiti-edgerouter-lite/

Assume the `xxx` in the examples below refers to the appropriate version of the `config.boot` file for your particular EdgeRouter. For example, on an EdgeRouter POE you'd use `config.boot.poe`.

Copy the raw contents of the appropriate `config.boot.xxx` file into your local clipboard.

Manually configure an IP address on your computer such as `192.168.1.19`, subnet `255.255.255.0` and default gateway `192.168.1.1`. Connect an Ethernet cable from your computer to the `eth0` port of the EdgeRouter (assuming factory default settings). 

Connect via `ssh` to your factory-defaulted router on `192.168.1.1` with username `ubnt` and password `ubnt`.

Create a blank `config.boot.xxx` file in `/home/ubnt` using the `vi` editor:

    sudo vi /home/ubnt/config.boot.xxx

Once inside the `vi` editor, turn off the auto-indenting feature before you paste by typing the following (including the colon):

    :set noai

and pressing `ENTER`. If you’re not familiar with `vi`, make sure you type the `:` whenever it's shown in this guide.

Enter the `insert` mode by pressing lowercase `i` (you don’t need `ENTER` after the `i` command).

Paste the contents of the copied raw `config.boot.xxx` file from your local system’s clipboard using your terminal client’s Paste menu item or keyboard shortcut (usually `CTRL-V` on PC, `Command-V` on Mac, etc.).

Exit `insert` mode by pressing the `ESC` key.

**W**rite and **q**uit your new `config.boot.xxx` file by typing:

    :wq

and then `ENTER`.

Copy your new `config.boot.xxx` file over the existing `config.boot` file with:

    sudo cp /home/ubnt/config.boot.xxx /config/config.boot

Reboot the router with `reboot` to apply the changes. It will ask you to confirm.

**IMPORTANT**: If you're using the `config.boot.poe` version of this configuration on an EdgeRouter PoE, make sure you disconnect the Ethernet cable connected to the `eth0` port *immediately* after you confirm the reboot. Once the reboot is finished, the `eth0` port will powered with 48v for the Google Fiber Jack and you shouldn't have any non-PoE clients attached to that port when it's powered. 

You're now ready to physically connect your EdgeRouter to the Google Fiber Jack and your LAN (refer to the **Port Settings** section above for the right cable locations).

**NOTE:** If you try to connect to your EdgeRouter immediately after the reboot, but can't ping or connect to it, make sure you're connected to a LAN port (such as `eth2`) instead of the WAN port (probably `eth0`) you were probably connected to while configuring.

# Google TV Considerations
My `config.boot` files used to include elements (inclduing igmp-proxy and multicast firewall settings) to enable Google TV on an EdgeRouter. However, Google had a terrible habit of changing the multicast addresses and settings without warning, thereby breaking Google TV service on the EdgeRouter. The Google TV settings are no longer part of my suggested configurations.

For Google TV users only, I now recommend installing a simple Gigabit switch, such as the [NETGEAR GS105NA](http://amzn.to/2nIAaVZ), "downstream" of the Google Fiber jack, then connecting both the Google Fiber TV box and the EdgeRouter's WAN port to separate ports on the Gigabit switch. This separates the Google TV service from the EdgeRouter and will allow everything to function normally without having to chase down changing settings at Google's whim.

# Google Fiber IPv6 Considerations
Based on the most recent IPv6 information from Google, residential customers should be requesting IPv6 addressing
with a prefix length of `/56` (which is what is used in these examples).

If you ever edit the IPv6 settings in your `config.boot` via the EdgeRouter CLI and want to apply them immediately, do:

    $ release dhcpv6-pd interface eth0
    $ delete dhcpv6-pd duid 
    $ renew dhcpv6-pd interface eth0

Change `eth0` as needed to match your configuration's WAN interface.

# Test IPv6 Connectivity
Test your connection for IPv6 support by visiting these websites:
* http://ipv6-test.com/
* http://test-ipv6.com/
* http://testmyipv6.com/
* http://ipv6test.google.com/
* http://ipv6leak.com/

# Support
Support for using these files is on this thread in the UBNT EdgeMax forums:

https://community.ubnt.com/t5/EdgeMAX/Updated-Google-Fiber-EdgeRouter-Lite-PoE-IPv4-amp-IPv6-config/m-p/1790440
