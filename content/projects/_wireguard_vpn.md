---
title: "Wireguard Raspberry Pi VPN Server Setup"
description: "How to Setup an Encrypted Connection In Your Home Network"
date: 1999-11-26
hideSummary: true
ShowWordCount: true
ShowReadingTime: true
ShowToC: true
draft: true

cover:
  image: 
  alt: Image of wireguard and pihole

tags: [⚙️ Computing]
---

## Miscellaneous Bluetooth Tasks
- Its important to set up a robust bluetooth keyboard system that can connect reliably each time you poweron the pi.

You can access the bluethooth cli by typing "bluetoohctl"

The most useful commands are:
- power on - turns on bluetooth system
- pairable on - sets controller to be in pairable mode
- scan on - starts scanning for device mac addresses in the bluetooth range/vicinity
- pair <device mac address> - attempts to pair the device e.g. keyboard
- trust <device mac address> - will remember the paired device and will auto connect to device next time its powered on
- exit - quits cli tool

This is vital if you need bluetooth devices to function properly if the raspberry pi powers on or off at various points and you need to configure it.

## Miscellaneous SSH into Pi
You won't need the bluetooth if you just ssh into the device.
- Simply type: ssh <piHostName>@<piDeviceIpAddress>
- Then login in via the pi's login credentials

## Wireguard - Setup VPN Software on Host
- Visit ![PIVPN Website](https://pivpn.io) for wireguard installation instructions - Has Installer Script For Wireguard or OpenVPN
- sudo apt-get update && apt-get upgrade
- Use following command curl -L https://install.pivpn.io | bash
- Follow install instructions:
    - Identify if DHCP Reservation is Enabled - DCHP is a protocol where each device connected on a local network is assigned a separate IP address-  By default I do not. - In the Sky Router I later define a IP address reservation so I can keep it for the same device.
    - Select static IP address  - again, we will make an IP address reservation for the device (on the router).
    - Choose wireguard VPN
    - Choose pi user to save configurations to
    - Select DNS provider - I picked Quad9 DNS
    - Select Port the Raspberry PI will be listening through (for UDP protocols) - By default its 51820 - it can be changed - but we need to open the port on the router firewall
    - We are connecting via a public IP address which is fine since we have chosen a static IP
    - Reboot
- pivvpn -a to add user (client machine aka pc or mobile define for example)
- This will generate a config file in /home/pi/config/<NAMEofCLIENTCONFIG.conf>
- You can copy this config to client by runnning Secure Copy for example or any other method you like.
- scp raspberrypi@192.---.---.--:/home/pi/config/<NAMEofCLIENTCONFIG.conf> /path/to/folder/in/client/machine

## Wireguard - Setup VPN Software on Client
- Download wireguard for Windows Client and Install to Computer
- Take the client configuration and "Add Tunnel" -- The configuration contains the relevant keys for connecting to the VPN Server.
- The VPN tunnel will allow the client to encrypt the traffic and sent it to the Pi which then pipes into the router and thus keeping your data packets encrypted and secure.
- Now we cannot connect yet until we fix the firewall settings in the router and enable the port forwarding

## Router Firewall/Security
From this point, the steps will be very specific to your model router and internet service provider. But we want to set the firewall rules and port to enable traffic from 
- In your browser enter the IP address of the router
- Go to LAN TCP/IP Setup and a "Address Reservation" - IP of device, Device Name and MAC address of device
- Reboot Hub
- Create service type UDP that listens in on Port 51820:51820 (the raspberrypi vpn port we set earlier)
- Firewall rules add INBOUND firewall rule for the service we just created and add an action to ALLOW always and if you want you can specify appliable IP address that it can connect from.
- Apply

From this point it should all be set up. You can go to the client machine on the wireguard app and activate the VPN tunnel connection. Hopefully, everything will be able to connect and you will have encypted traffic routing through the raspberry Pi.

## Pihole - Set Network wide Adblocker
Visit ![Pi-hole Website](https://pi-hole.net) for installation instructions.
To install pihole:
- curl -sSL https://install.pi-hole.net | bash
- Go through installation process and also ensure that you have a static IP address selected
- We will later create our own DNS Server using unbound after the installation
- Pihole will give you a password by default but you can change it with sudo pihole -a -p <newPassword>
- Go into the browser and login into pihole by accessing your Pi's IP address via the browser: i.e. http://192.---.--.--/admin
- Use you pihole credentials to login

## Unbound - Set Local Recursive Self Hosted DNS Server 
Visit ![Unbound Installation](https://docs.pi-hole.net/guides/dns/unbound/)
To install unbound:
- sudo apt-get install unbound
- Create file /etc/unbound/unbound.conf.d/pi-hole.conf
- Change the port number to 5335. Pihole is using port 53 so we dont want to share the same port, so we will put in in this one. Configuration should look like this:
```bash
server:
    # If no logfile is specified, syslog is used
    # logfile: "/var/log/unbound/unbound.log"
    verbosity: 0

    interface: 127.0.0.1
    port: 5335
    do-ip4: yes
    do-udp: yes
    do-tcp: yes

    # May be set to yes if you have IPv6 connectivity
    do-ip6: no

    # You want to leave this to no unless you have *native* IPv6. With 6to4 and
    # Terredo tunnels your web browser should favor IPv4 for the same reasons
    prefer-ip6: no

    # Use this only when you downloaded the list of primary root servers!
    # If you use the default dns-root-data package, unbound will find it automatically
    #root-hints: "/var/lib/unbound/root.hints"

    # Trust glue only if it is within the server's authority
    harden-glue: yes

    # Require DNSSEC data for trust-anchored zones, if such data is absent, the zone becomes BOGUS
    harden-dnssec-stripped: yes

    # Don't use Capitalization randomization as it known to cause DNSSEC issues sometimes
    # see https://discourse.pi-hole.net/t/unbound-stubby-or-dnscrypt-proxy/9378 for further details
    use-caps-for-id: no

    # Reduce EDNS reassembly buffer size.
    # IP fragmentation is unreliable on the Internet today, and can cause
    # transmission failures when large DNS messages are sent via UDP. Even
    # when fragmentation does work, it may not be secure; it is theoretically
    # possible to spoof parts of a fragmented DNS message, without easy
    # detection at the receiving end. Recently, there was an excellent study
    # >>> Defragmenting DNS - Determining the optimal maximum UDP response size for DNS <<<
    # by Axel Koolhaas, and Tjeerd Slokker (https://indico.dns-oarc.net/event/36/contributions/776/)
    # in collaboration with NLnet Labs explored DNS using real world data from the
    # the RIPE Atlas probes and the researchers suggested different values for
    # IPv4 and IPv6 and in different scenarios. They advise that servers should
    # be configured to limit DNS messages sent over UDP to a size that will not
    # trigger fragmentation on typical network links. DNS servers can switch
    # from UDP to TCP when a DNS response is too big to fit in this limited
    # buffer size. This value has also been suggested in DNS Flag Day 2020.
    edns-buffer-size: 1232

    # Perform prefetching of close to expired message cache entries
    # This only applies to domains that have been frequently queried
    prefetch: yes

    # One thread should be sufficient, can be increased on beefy machines. In reality for most users running on small networks or on a single machine, it should be unnecessary to seek performance enhancement by increasing num-threads above 1.
    num-threads: 1

    # Ensure kernel buffer is large enough to not lose messages in traffic spikes
    so-rcvbuf: 1m

    # Ensure privacy of local IP ranges
    private-address: 192.168.0.0/16
    private-address: 169.254.0.0/16
    private-address: 172.16.0.0/12
    private-address: 10.0.0.0/8
    private-address: fd00::/8
    private-address: fe80::/10
```

- Save and quit
- Restart the service by using command: sudo service unbound restart
- Check its working with command: dig pi-hole.net @127.0.0.1 -p 5335

## Going back to the Pi-Hole Website Interface
- Go to the DNS settings and uncheck all the 3rd party Upstream DNS servers
- Add a custom IPv4 Address: 127.0.0.1#5335
- Save and apply the changes

## Going back to the Client Machine
We need to route the DNS requests via the raspberry pi.
- Access your clients network connections and remove all the other DNS values.
- Replace with preferred DNS IP address: aka. IP address of Raspberry Pi -- This will now become your recursive DNS server
- Check your Pi-hole and you should see that queries are routing though the Pi as you use the internet and a percentage of them are getting blocked









