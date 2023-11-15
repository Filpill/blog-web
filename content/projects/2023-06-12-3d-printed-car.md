---
title: "3D Printed RC Road Vehicle"
description: "Showcasing design and build of the latest iteration of my 3D printed car"
date: 2023-06-12
hideSummary: true
ShowWordCount: true
ShowReadingTime: true
draft: false
ShowToC: true

cover:
  image : img/tractor/rc_car_full.png
  alt: 'Solidworks Render of Tractor'

categories: [Engineering]
---

## Summary

Finshed designing and building a functional 3D Printed RC car which accidently ended up resembling a tractor by chance. Thats the consequence of a lack of planning and design contraints...

The reason for the large wheels in the back is because of how I started my design process. The design was built around the gearbox. Since the gearbox ended up being very tall, I figured I would just mount some very large wheels to clear the ground. Therefore I didn't need to think about mounting points for the rear wheel, nor a CV jointed drive shaft. It was simply direct drive and it was all 3D printed (except the steering mechanism).

After doing some testing on the rear drive-shaft, it was soon discovered to be necessary to bw printed sideways. This is to take advantage of the directional strength of the 3D printed layers so they can tolerate a degree of torque. I made them mistake of printing the shafts vertically, however this drive-train produces incredible amounts of torque such that the plastic drive shaft failed in 10 seconds of run time. Layer adhesion alone is definitely not strong enough to withstand a large torgue being applied to a small cross-section.

I wanted to make my design as simple as reasonably possible. In my previous projects, trying to implement a suspension was fairly complicated and I had limited spare time I had outside of my 9-5. My only goal was to get a suitable functional prototype car.

I did end up using the lessons from my previous failed car designs to incorporate into this one. I had a 2 year hiatus from designing anything mechanical, so I suprised even myself when I managed to build out a working 3D printed gearbox.

It's not perfect by any stretch of the imagination; after the assembly I still had to take a dremel to various parts to shave off some millimeters in order to free up mechanisms and part fits. Even after checking for collisions in Solidworks, the clearances and fits may not be what you expect in real life.

If I design more cars in the future, I will try make more thoughtful and elegant designs with improved tolerancing. Even after 4 years of 3D printing, its not straightforward to nail down the tolerancing. To be honest, I think it is extremely reliant on trial an error to nail down correctly, but at least its at the point of acceptability for this design.


## General Car Stats

- Dimensions: Approx. 300mm x 230mm
- Weight: Approx 1.2kg (including electronics)
- Motor: 550/35T
- Battery: 11.1V 3S LiPo
- Servo: MG995-R
- Plastic Used: PLA

## Design Photos

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


## Gifs

{{< img720 src = "/img/tractor/steering_range.gif" >}}

{{< img720 src = "/img/tractor/rc_turn.gif" >}}
