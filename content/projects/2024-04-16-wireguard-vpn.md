---
title: "WireGuard VPN Server"
description: "How to Setup an Encrypted VPN Tunnel To Access Your Home Network"
date: 2024-04-16
hideSummary: true
ShowWordCount: true
ShowReadingTime: true
ShowToC: true
draft: false

cover:
  image: /img/vpn/wireguard_banner.png
  alt: Image of wireguard banner

tags: [💻 Systems]
---

## Summary

This guide will quickly provide instructions on how to set up a self-hosted WireGuard VPN encrypted tunnel to access you home network. This will be especially handy if you are on a public Wi-Fi connection and need your data to remain secure.

We will also go through the steps of adding pi-hole to the device to include network wide adblock by blocking a list of domains which will try to render unnecessary advertising to us.

For this exercise I will be installing WireGuard onto a RaspberryPi, but you can do this ostensibly with any computer. I will assume that you already know how to SSH into your target device, because we are going to do this all on the command line.

## Why Do I Need A Self-Hosted VPN?
You will need a VPN if you are trying to access your home network/home devices from another location. The VPN will "tunnel" the connection to your home's local network allowing you to access devices via SSH or RDP. You only need to expose a single port in your router that is accessible to the public.

## WireGuard - Server Host
- Visit [PIVPN Website](https://pivpn.io) for WireGuard installation instructions - Has Installer Script For WireGuard or OpenVPN
- sudo apt-get update && apt-get upgrade
- Use following command curl -L https://install.pivpn.io | bash
- Follow install instructions:
    - Identify if DHCP Reservation is Enabled - DCHP is a protocol where each device connected on a local network is assigned a separate IP address. You will want to make sure that its enabled such that we can do the port forwarding for it.
    - In the Router I later define a IP address reservation so I can maintain the same IP address for the RaspberryPi.
    - Select static IP address  - again, we will make an IP address reservation for the device (on the router).
    - Choose WireGuard VPN
    - Select user which will store WireGuard configurations
    - Select DNS provider - I picked Quad9 DNS, but the choice is yours.
    - Select the port RaspberryPi will be listening through (for UDP protocol/traffic) - By default its 51820 - it can be changed - but we need to open the port on the router firewall
    - We are connecting via a public IP address which is fine since we have chosen a static IP
    - Reboot
- pivvpn -a to add user (client machine aka pc or mobile define for example)
- This will generate a config file in /home/pi/config/<NAMEofCLIENTCONFIG.conf>
- You can copy this config to client by running the Secure Copy Protocol for example or any other method you like.
- scp raspberrypi@192.---.---.--:/home/pi/config/<NAMEofCLIENTCONFIG.conf> /path/to/folder/in/client/machine
- You can also copy configurations with QR codes if you want.

## Router Firewall and Port Forwarding
Router firewall procedures will be very specific to your model router and internet service provider. But we want to set the firewall rules and port to enable traffic to the VPN Server.
- In your browser enter the IP address of the router i.e. the "Default Gateway" address.
- Go to LAN TCP/IP Setup and a "Address Reservation" - IP of device, Device Name and MAC address of device. The device in question could be one of your PC's or mobile phones.
- Reboot Hub
- Create service type UDP that listens in on Port 51820:51820 (the raspberrypi vpn port we set earlier)
- Firewall rules add INBOUND firewall rule for the service we just created and add an action to ALLOW always and if you want you can specify applicable IP address that it can connect from.
- Apply the changes to the router.

## WireGuard - Client Machine
Now we just need the configuration file that we copied earlier which contains keys (and config) to connect the client to the VPN server.
- Download WireGuard for Windows Client and Install to Computer
- Take the client configuration and "Add Tunnel" -- The configuration contains the relevant keys for connecting to the VPN Server.
- The VPN tunnel will allow the client to encrypt the traffic and sent it to the Pi which then pipes into the router and thus keeping your data packets encrypted and secure.
- From a VPN perspective, that's it, you should be able to connect to your home network externally.

And since we've gone through the trouble of creating a VPN, you may as well enable adblocking in addition to a locally hosted recursive DNS Server.

## Pi-hole - Adblocker
Pihole will help prevent intrusive ads that try to target your device. This can be configure as a network-wide adblock capture to protect all devices.

Visit [Pi-hole Website](https://pi-hole.net) for installation instructions.
To install pihole:
- curl -sSL https://install.pi-hole.net | bash
- Go through installation process and also ensure that you have a static IP address selected
- We will later create our own DNS Server using unbound after the installation
- Pihole will give you a password by default but you can change it with sudo pihole -a -p <newPassword>
- Go into the browser and login into pihole by accessing your Pi's IP address via the browser: i.e. http://192.---.--.--/admin
- Use you pihole credentials to login

## Unbound - Self Hosted Recursive DNS Server 
If you value your privacy, you may consider hosting your own DNS server. Why? Because your internet traffic gets routed to DNS servers such as CloudFlare or Google which are resolving your queries (even if you have a VPN tunnel enabled!).

The companies who own the DNS servers can see which IP addresses are querying which domains, so essentially they have a full view of your query history which all links back to your IP address.

Even if you are "private browsing" all these queries are hitting their servers and its a mystery what DNS server providers are doing with your data:
- Are they collecting/storing it?
- Are they selling it to companies?
- Do they themselves "profile" individuals?
- Do they provide data to various government entities?
- How much should I trust these companies?

At the end of the day, you should already know how valuable your data is, because all the advertising designed to manipulate you into a non-stop consumer. 

And here's food for though, if this data is worth millions or billions, then we should not give it away for freely -- at least make them work for it...

Anyways, if you are still interested in setting up this DNS server, see below instructions:

Visit [Unbound Installation](https://docs.pi-hole.net/guides/dns/unbound/) for installation instructions.

To install unbound:
- sudo apt-get install unbound
- Create file /etc/unbound/unbound.conf.d/pi-hole.conf
- Change the port number to 5335. Pihole is using port 53 so we dont want to share the same port, hence the usage of port 5335.
- Save and quit
- Restart the service by using command: sudo service unbound restart
- Check its working with command: dig pi-hole.net @127.0.0.1 -p 5335

## DNS Settings on Pi-Hole Website Interface
- Go to the DNS settings and uncheck all the 3rd party Upstream DNS servers
- Add a custom IPv4 Address: 127.0.0.1#5335
- Save and apply the changes

## DNS Settings on Client Machine
We need to route the DNS requests via the RaspberryPi.
- Access your clients network connections and remove all the other DNS values.
- Replace with preferred DNS IP address: aka. IP address of RaspberryPi -- This will now become your recursive DNS Server.
- Check your Pihole and you should see that queries are routing though the Pi as you use the internet and a percentage of them are getting blocked by the adblocker.
