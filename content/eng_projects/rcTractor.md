---
title: "3D Printed RC Tractor"
date: 2023-06-12
draft: True
ShowToC: false

cover:
  image : img/tractor/rc_car_full.png
  alt: 'Solidworks Render of Tractor'

tags: ["design","engineering","mechanical","3d-printing"]
categories: ["engineering","design"]
---

# Summary

Finshed designing and building a functional 3D Printed RC car which accidently ended up esembling a tractor by chance. Thats the consequence of a lack of planning and design contraints...

The reason for the large wheels in the back is because of how I started my design process. The design was built around the gearbox. Since the gearbox ended up being very tall, I figured I would just mount some very large wheels to clear the ground. Therefore I didn't need to think about mounting points for the rear wheel, nor did I need a drive shaft with a CV joint, it was simply direct drive.

Furthermore with regards to the rear drive-shaft, after some testing it was necessary to be  printed sideways to take advantage of the directional strength of the 3D printed layers when applying a torque. Initially I made them mistake of printing the shafts vertically, however this system produces so much torque that the wheels gave out in about 10 seconds of run time. Layer adhesion alone is definitely not strong enhance to withstand a large torgue being applied to a small cross-section.

I wanted to make my design as simple as reasonably possible. In my previous projects, trying to implement a suspension was fairly complicated and I had limited spare time I had outside of my 9-5. My only goal was to get a suitable functional prototype car.

I did end up using the lessons from my previous failed car designs to incorporate into this one. I had a 2 year hiatus from designing anything mechanical, so I suprised even myself when I managed to build out a working 3D printed gearbox.

Not sure what my future plans will be, but I will try make more elegant designs with improved tolerances. Even after 4 years of 3D printing, its not straightforward to nail down the tolerancing. To be honest, I think it is extremely reliant on trial an error to nail down correctly, but at least its at the point of acceptability for this design.


## General Car Stats

- Dimensions: Approx. 300mm x 230mm
- Weight: Approx 1.2kg (including electronics)
- Motor: 550/35T
- Battery: 11.1V 3S LiPo
- Servo: MG995-R
- Plastic Used: PLA

# Design Photos

Here are some renders made in Solidworks:

## Front View
![Image1](/img/tractor/rc_car_front.png)
## Side View
![Image2](/img/tractor/rc_car_side.png)
## Top View
![Image3](/img/tractor/rc_car_top.png)
## Rear View
![Image3](/img/tractor/rc_car_rear_top.png)
## Front Wheel Hub - Close Up
![Image4](/img/tractor/rc_tractor_front_wheel.png)
## Gearbox - Close Up
![Image5](/img/tractor/rc_tractor_gears.png)
## Steering Articulation
![Image6](/img/tractor/rc_tractor_steeringL.png)
![Image7](/img/tractor/rc_tractor_steeringR.png)

