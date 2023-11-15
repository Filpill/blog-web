---
title: "Cyber Deck Assembly - Raspberry Pi"
description: "3D Printed frame for Raspberry Pi featuring integrated camera and display"
date: 2023-07-10
hideSummary: true
ShowWordCount: true
ShowReadingTime: true
draft: false
ShowToC: true

cover:
  image : img/cyberDeck/frontNeofetch.jpg
  alt: 'CyberDeck Assembly'

categories: [Engineering]
---

## Summary

I've designed out a "cyber deck"/frame for my Raspberry Pi to convert it into a usable personal computer. It features a 7 inch touch display and a web camera plugged into the boards DSI (Display Serial Interface) connectors. Should the design become more compact in the future, the ribbon cables are ideal for routing inside tight enclosures.

The only necessary wired connection is a USB-C to provide power to the board. I've got my keyboard and mouse connected wirelessly via bluetooth to maintain control of the Raspberry Pi. This avoids having to constantly plug devices in and out between the Pi and my main PC.

In order to regulate the temperature of the Pi, I've mounted a 3V fan onto the PCB to cool the Pi's CPU and memory chips. This is to maintain the peak performance of the chips in question.

The open back design also enables easy access to the GPIO headers should you need to plug in and program your electronics. I'll hook up some servo's and play around with them with the Pi using Python. 



## Raspberry Pi Assembly

![offDisplay](/img/cyberDeck/offDisplay.jpg)
![Fan](/img/cyberDeck/backFan.jpg)
![Bacj Connec](/img/cyberDeck/backConnectors.jpg)
