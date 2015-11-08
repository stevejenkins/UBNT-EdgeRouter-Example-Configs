firewall {
    all-ping enable
    broadcast-ping disable
    ipv6-receive-redirects disable
    ipv6-src-route disable
    ip-src-route disable
    log-martians enable
    name WAN_IN {
        default-action drop
        description "WAN to Internal"
        enable-default-log
        rule 1 {
            action accept
            description "Allow established/related"
            log disable
            state {
                established enable
                related enable
            }
        }
        rule 2 {
            action drop
            description "Drop invalid state"
            log enable
            state {
                invalid enable
            }
        }
    }
    name WAN_LOCAL {
        default-action drop
        description "WAN to Router"
        enable-default-log
        rule 1 {
            action accept
            description "Allow established/related"
            log disable
            state {
                established enable
                related enable
            }
        }
        rule 2 {
            action drop
            description "Drop invalid state"
            log enable
            state {
                invalid enable
            }
        }
    }
    options {
        mss-clamp {
            interface-type all
            mss 1460
        }
    }
    receive-redirects disable
    send-redirects enable
    source-validation disable
    syn-cookies enable
}
interfaces {
    ethernet eth0 {
        address 192.168.1.1/24
        description LAN
        duplex auto
        speed auto
    }
    ethernet eth1 {
        description "Google Fiber Jack"
        duplex auto
        speed auto
        vif 2 {
            address dhcp
            address dhcpv6
            description "Google Fiber WAN"
            egress-qos 0:3
            firewall {
                in {
                    name WAN_IN
                }
                local {
                    name WAN_LOCAL
                }
            }
        }
    }
    ethernet eth2 {
        address 192.168.100.1/24
        description "Local Config Port"
        duplex auto
        speed auto
    }
    loopback lo {
    }
}
service {
    dhcp-server {
        disabled false
        hostfile-update disable
        shared-network-name LAN {
            authoritative disable
            subnet 192.168.1.1/24 {
                default-router 192.168.1.1
                dns-server 8.8.8.8
                dns-server 8.8.4.4
                lease 86400
                start 192.168.1.20 {
                    stop 192.168.1.225
                }
            }
        }
    }
    dns {
        forwarding {
            cache-size 150
            listen-on eth0
        }
    }
    gui {
        https-port 443
    }
    nat {
        rule 5000 {
            description "Masquerade for WAN"
            log disable
            outbound-interface eth1.2
            protocol all
            type masquerade
        }
    }
    ssh {
        port 22
        protocol-version v2
    }
    upnp2 {
        listen-on eth0
        nat-pmp disable
        secure-mode disable
        wan eth1.2
    }
}
system {
    host-name ubnt
    login {
        user ubnt {
            authentication {
                encrypted-password $1$zKNoUbAo$gomzUbYvgyUMcD436Wo66.
            }
            level admin
        }
    }
    name-server 8.8.8.8
    name-server 8.8.4.4
    ntp {
        server 0.ubnt.pool.ntp.org {
        }
        server 1.ubnt.pool.ntp.org {
        }
        server 2.ubnt.pool.ntp.org {
        }
        server 3.ubnt.pool.ntp.org {
        }
    }
    syslog {
        global {
            facility all {
                level notice
            }
            facility protocols {
                level debug
            }
        }
    }
    time-zone America/Denver
}


/* Warning: Do not remove the following line. */
/* === vyatta-config-version: "config-management@1:conntrack@1:cron@1:dhcp-relay@1:dhcp-server@4:firewall@5:ipsec@4:nat@3:qos@1:quagga@2:system@4:ubnt-pptp@1:ubnt-util@1:vrrp@1:webgui@1:webproxy@1:zone-policy@1" === */
/* Release version: v1.7.0.4783374.150622.1534 */
