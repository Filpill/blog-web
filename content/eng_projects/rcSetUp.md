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

This article will briefly outline the basic arrangement that can be used as guidance for your DIY RC electronics.

Any of these specific parts that are mentioned here can be interchanged for your specific needs. The list of parts outlined is the minumum number of components to have a functioning motor and servo.


# Parts List

<div align="center">

Component      | Part No. 
| :---        |    :----
| Radio Controller/Transmitter | FS-GT5 
| Radio Reciever | FS-BS6 
| Electronic Speed Controller (ESC) | KYRC X60 - Brush
| Battery Eliminary Curcuit (BEC) | KYRC X60 - Brush
| Lipo Voltage Indicator | Youmile Battery Tester
| Brushed/Brushless Motor | 550/35T *"CrazyPony"* Brushed 
| Servo | MG-996R 
| LiPo Battery | 11.1V 3S HRB Power 
| Battery Balence Charger/Discharger | HTRC T150 

</div>

# Type of Electrical Connectors
Component | Connector
| :---        |    :----
ESC | Traxxas, Deans/T-Plug, Motor Pin
Battery | Traxxas, Deans/T-Plug
Motor | Motor Pin 
Servo | Futaba Connector
Voltage Alarm | JST XH
Balance Charger | JST XH


# Block Connection Diagram

Here is the component block diagram:

{{<mermaid>}}
mindmap
    root((ESC))
        Motor
        BEC
            Reciever
                Servo
        Battery
            Voltage Indicator

{{< /mermaid >}}

The ESC as the hub of the system in which everything connects to. The ESC on my system also happens peform the functionalilty of the BEC and can be considered as one unit.




# LiPo Battery Maintenance
Safety Precautions should be taken when using LiPo batteries, they can be very dangerous if mishandled. If you are not using the LiPo's when they are in a "charged" state, then you should consider discharging them to a "storage voltage". A safe storage voltage per cell is somewhere between 3.6V and 3.8V.

The maximum allowable voltage of a LiPo cell is 4.2V per cell. Do not overcharge the battery as you may cause damage to the battery and reduce the lifespan; it may also become a fire hazard if consitently overcharged. You may see ballooning occur in the battery. This will be a sign to discontinue use of the battery.

In terms of charging rates, I am charging my batteries at a rate of 1C. For a 2200mAH battery this equates to 2.2A.

The inverse is true about discharging the battery too much. Do not let the LiPo voltage fall below 3.2V per cell as this will also cause internal damage to the battery which is irreversible. To mitigate this risk, you can use a voltage alarm on your circuit to warn you when the voltage is falling below a desired threshold.


# Photos

![Image1](/img/folder/imageName.jpg)

