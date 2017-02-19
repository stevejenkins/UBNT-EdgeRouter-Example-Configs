firewall {
    all-ping enable
    broadcast-ping disable
    ipv6-name WANv6_IN {
        default-action drop
        description "WANv6 inbound traffic forwarded to LAN"
        rule 10 {
            action accept
            description "Allow established/related"
            state {
                established enable
                related enable
            }
        }
        rule 20 {
            action drop
            description "Drop invalid state"
            state {
                invalid enable
            }
        }
        rule 30 {
            action accept
            description "Allow ICMPv6"
            log disable
            protocol icmpv6
        }
    }
    ipv6-name WANv6_LOCAL {
        default-action drop
        description "WANv6 inbound traffic to the router"
        rule 10 {
            action accept
            description "Allow established/related"
            state {
                established enable
                related enable
            }
        }
        rule 20 {
            action drop
            description "Drop invalid state"
            state {
                invalid enable
            }
        }
        rule 30 {
            action accept
            description "Allow ICMPv6"
            log disable
            protocol icmpv6
        }
        rule 40 {
            action accept
            description "Allow DHCPv6"
            destination {
                port 546
            }
            protocol udp
            source {
                port 547
            }
        }
    }
    ipv6-name WANv6_OUT {
        default-action accept
        description "WANv6 outbound traffic"
        rule 10 {
            action accept
            description "Allow established/related"
            state {
                established enable
                related enable
            }
        }
        rule 20 {
            action reject
            description "Reject invalid state"
            state {
                invalid enable
            }
        }
    }
    ipv6-receive-redirects disable
    ipv6-src-route disable
    ip-src-route disable
    log-martians enable
    name LAN_IN {
        default-action accept
        description "LAN to Internal"
        rule 10 {
            action drop
            description "Drop invalid state"
            state {
                invalid enable
            }
        }
    }
    name WAN_IN {
        default-action drop
        description "WAN to internal"
        rule 10 {
            action accept
            description "Allow established/related"
            log disable
            state {
                established enable
                invalid disable
                new disable
                related enable
            }
        }
       rule 20 {
            action accept
            description "Allow ICMP"
            log disable
            protocol icmp
            state {
                established enable
                related enable
            }
        }
        rule 100 {
            action drop
            description "Drop invalid state"
            protocol all
            state {
                established disable
                invalid enable
                new disable
                related disable
            }
        }
    }
    name WAN_LOCAL {
        default-action drop
        description "WAN to router"
        rule 10 {
            action accept
            description "Allow established/related"
            state {
                established enable
                related enable
            }
        }
        rule 20 {
            action accept
            description "Port Forward - Router SSH"
            destination {
                address 192.168.1.1
                port 22
            }
            protocol tcp
        }
        rule 30 {
            action accept
            description "Port Forward - Router HTTPS"
            destination {
                address 192.168.1.1
                port 443
            }
            protocol tcp
        }
        rule 100 {
            action drop
            description "Drop invalid state"
            protocol all
            state {
                established disable
                invalid enable
                new disable
                related disable
            }
        }
    }
    name WAN_OUT {
        default-action accept
        description "Internal to WAN"
        rule 10 {
            action accept
            description "Allow established/related"
            log disable
            state {
                established enable
                related enable
            }
        }
        rule 20 {
            action reject
            description "Reject invalid state"
            state {
                invalid enable
            }
        }
    }
    options {
        mss-clamp {
            interface-type all
            mss 1412
        }
    }
    receive-redirects disable
    send-redirects enable
    source-validation disable
    syn-cookies enable
}
interfaces {
    ethernet eth0 {
        address dhcp
        description WAN
        dhcpv6-pd {
            pd 0 {
                interface eth1 {
                    host-address ::1
                    prefix-id :0
                    service slaac
                }
                interface eth1.102 {
                    host-address ::1
                    prefix-id :1
                    service slaac
                }
                interface eth2 {
                    host-address ::1
                    prefix-id :2
                    service slaac
                }
                prefix-length /60
            }
            rapid-commit enable
        duplex auto
        firewall {
            in {
                ipv6-name WANv6_IN
                name WAN_IN
            }
            local {
                ipv6-name WANv6_LOCAL
                name WAN_LOCAL
            }
            out {
                ipv6-name WANv6_OUT
                name WAN_OUT
            }
        }
        speed auto
    }
    ethernet eth1 {
        address 192.168.99.1/24
        description "Local Config"
        duplex auto
        firewall {
            in {
                name LAN_IN
            }
        }
        speed auto
    }
    loopback lo {
    }
    ethernet eth2 {
        address 192.168.1.1/24
        description LAN
        duplex auto
        firewall {
            in {
                name LAN_IN
            }
        }
        mtu 1500
        speed auto
        vif 102 {
            address 10.0.0.1/24
            description "Guest Network VLAN"
            mtu 1500
        }
    }
}
port-forward {
    auto-firewall enable
    hairpin-nat enable
    lan-interface eth2
    rule 10 {
        description "Router SSH"
        forward-to {
            address 192.168.1.1
            port 22
        }
        original-port 2222
        protocol tcp_udp
    }
    rule 20 {
        description "Router HTTPS"
        forward-to {
            address 192.168.1.1
            port 443
        }
        original-port 8080
        protocol tcp_udp
    }
    wan-interface eth0
}
service {
    dhcp-server {
        disabled false
        hostfile-update enable
        shared-network-name Guest {
            authoritative disable
            subnet 172.16.0.0/24 {
                default-router 172.16.0.1
                dns-server 8.8.8.8
                dns-server 8.8.4.4
                domain-name guest.example.com
                lease 86400
                start 172.16.0.10 {
                    stop 172.16.0.254
                }
            }
        }
        shared-network-name LAN {
            authoritative disable
            subnet 192.168.1.0/24 {
                default-router 192.168.1.1
                dns-server 192.168.1.1
                dns-server 8.8.8.8
                dns-server 8.8.4.4
                domain-name example.com
                lease 86400
                start 192.168.1.101 {
                    stop 192.168.1.254
                }
            }
        }
        shared-network-name Config {
            authoritative disable
            subnet 192.168.99.0/24 {
                default-router 192.168.99.1
                dns-server 8.8.8.8
                dns-server 8.8.4.4
                lease 86400
                start 192.168.99.101 {
                    stop 192.168.99.255
                }
            }
        }
        use-dnsmasq disable
    }
    dns {
        forwarding {
            cache-size 500
            listen-on eth2
            name-server 2001:4860:4860::8888
            name-server 2001:4860:4860::8844
            name-server 8.8.8.8
            name-server 8.8.4.4
        }
    }
    gui {
        http-port 80
        https-port 443
        older-ciphers enable
    }
    nat {
        rule 5000 {
            description "Masquerade for WAN"
            log disable
            outbound-interface eth0
            protocol all
            type masquerade
        }
    }
    ssh {
        port 22
        protocol-version v2
    }
    upnp2 {
        listen-on eth2
        nat-pmp disable
        secure-mode enable
        wan eth0
    }
}
system {
    host-name UBNT-gateway
    login {
        user ubnt {
            authentication {
                encrypted-password $1$zKNoUbAo$gomzUbYvgyUMcD436Wo66.
                plaintext-password ""
            }
            full-name "UBNT Admin"
            level admin
        }
    }
    name-server 2001:4860:4860::8888
    name-server 2001:4860:4860::8844
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
    offload {
        hwnat disable
        ipsec enable
        ipv4 {
            forwarding enable
            vlan enable
        }
        ipv6 {
            forwarding enable
            vlan enable
        }
    }
    package {
        repository wheezy {
            components "main contrib non-free"
            distribution wheezy
            password ""
            url http://http.us.debian.org/debian
            username ""
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
    traffic-analysis {
        dpi enable
        export enable
    }
}

/* Warning: Do not remove the following line. */
/* === vyatta-config-version: "config-management@1:conntrack@1:cron@1:dhcp-relay@1:dhcp-server@4:firewall@5:ipsec@5:nat@3:qos@1:quagga@2:system@4:ubnt-pptp@1:ubnt-util@1:vrrp@1:webgui@1:webproxy@1:zone-policy@1" === */
/* Release version: v1.9.1.4939093.161214.0705 */
