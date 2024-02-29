---
title: "Steamlink Setup"
description: "How to set up steamlink on a Raspberry Pi"
date: 2024-02-24
hideSummary: true
ShowWordCount: true
ShowReadingTime: true
ShowToC: true
draft: true

cover:
  image: /img/xxx/xxx.png
  alt: qwe

categories: [Data]
---

# Summary
This article will discuss how you can set-up a raspberry pi in order to stream games locally to your television. A similar process will apply to any spare computer/laptop.

## Imaging the Pi
Since this will be a single purpose Pi, we won't expressly required a fully featured desktop environment and have therefore decided to keep the installation minimal by just loading in a copy of Raspberry Pi Lite OS.

Something worth noting (at the time of writing) is that the steamlink program is not compatible with the newer versions of Debian 11 or 12. Steamlink is only supported for Debian 10, so that is the version I recommend putting on your device.

## Configuration
You will need to do the following tasks to set up the pi:
1. Add a new user with password and sudo permissions
2. Change the default password of the root user
3. raspi-config: configure display and connect to wifi
4. Update system and install updates
5. Install steamlink
6. Add crontab entry to launch steamlink on rebooting the device.
