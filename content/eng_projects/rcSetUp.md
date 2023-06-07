---
title: "How to Set Up RC Electronic System"
date: 2023-06-07
draft: True
ShowToC: false

cover:
  image : img/folder/image.png
  alt: 'Image of RC Electronics'

tags: ["engineering","electronics"]
categories: ["engineering"]
---

# Summary

This article will briefly outline the basic arrangement that can be for your radio controlled electronics.

# Generic Parts List

- Radio Controller/Transmitter
- Radio Reciever
- Electronic Speed Controller (ESC)
- Battery Eliminary Curcuit (BEC) (Integrated with ESC)
- Lipo Battery Voltage Monitor/Alarm
- Brushed/Brushless Motor
- Servo
- LiPo Battery
- Battery Balence Charger/Discharger

# Part Numbers
- ESC: KYRC X60 - Brush - RTR
- RC Controller: FS-GT5
- RC Reciever: FS-BS6
- Servo: MG-996R
- Motor: 550T *"CrazyPony"*
- LiPo: 11.1V 3S HRB Power: 30C Discharge/60C Burst
- Battery Balancer: HTRC T150

# Type of Electrical Connectors Used
- Traxxas Connector (For Battery/ESC)
- Deans/T-Plug Connector (For Battery/ESC)
- Motor Pin (Motor/ESC)
- Futaba Connector (For Servo)
- JST XH (For Battery Balancing)

Any of these specific parts can be interchanged for your specific needs. The only thing required is to get the general list of parts connected in order to have a minimum of an operational motor plus servo.

# Block Connection Diagram

{{<mermaid>}}
graph TD;
    subgraph Connections
    A[ESC]-->B
    B[Battery]
    end
{{< /mermaid >}}

# LiPo Battery Maintenace
Safety Precautions should be taken when using LiPo batteries, they can be very dangerous if mishandled. If you are not using the LiPo's when they are in a "charged" state, then you should consider discharging them to a "storage voltage". A safe storage voltage per cell is somewhere between 3.6V and 3.8V.

The maximum allowable voltage of a LiPo cell is 4.2V. Do not overcharge the battery as you may cause damage to the battery and reduce the lifespan; it may also become a fire hazard if consitently overcharged. You may see ballooning occur in the battery. This will be a sign to discontinue use of the battery.

The inverse is true about discharging the battery too much. Do not let the LiPo voltage fall below 3.2V as this will also cause internal damage to the battery which is irreversible. To mitigate this risk, you can use a voltage alarm on your circuit to warn you when the voltage is falling below a desired threshold.

# Photos

![Image1](/img/folder/imageName.jpg)

