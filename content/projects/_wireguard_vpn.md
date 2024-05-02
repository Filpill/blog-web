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
  alt: Soldering

tags: [⚙️ Computing]
---

## Raspberry Pi Tasks
- Visit pivpn.io - Installer Script For Wireguard or OpenVPN
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

## Windows Tasks
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
