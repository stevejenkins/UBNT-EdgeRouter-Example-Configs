# Ubiquiti EdgeRouter / EdgeMax Example config.boot Files
This repo contains a collection of example **config.boot** files which you can use as a starting point
for configuring your UBNT EdgeRouter for IPv4 and IPv6 on a number of networks, including:

* Google Fiber
* Comcast Xfinity
* Charter Spectrum

# Usage
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

    $ configure
    # load
    # commit
    # save
    # exit
    
# IPv6 Considerations
If you edit the IPv6 settings in your `config.boot` and want to apply them immediately, do:

    $ release dhcpv6-pd interface eth0
    $ delete dhcpv6-pd duid 
    $ renew dhcpv6-pd interface eth0

Change `eth0` as needed to match your configuration's WAN interface.

# Test IPv6 Connectivity
Test your connection for IPv6 support by visiting these websites:
* https://ipv6-test.com/
* https://test-ipv6.com/
* http://testmyipv6.com/
* https://ipv6test.google.com/
* https://ipv6leak.com/
* https://ip6.me/
* https://ipinfo.io/
* https://ifconfig.me/
* https://ifconfig.co/
* https://api64.ipify.org/
* https://ident.me/
* https://checkip.amazonaws.com/
