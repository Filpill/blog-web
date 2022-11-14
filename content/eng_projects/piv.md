---
title: "Forward Facing Step - Particle Image Velocimetry"
date: 2017-06-01
draft: false
ShowToC: true

cover:
  image : img/piv/ffs-bl-diagram.png
  alt: 'PIV BL Diagram'

tags: ["design","engineering","laser","camera","imageJ","matlab","python","wind tunnel","aerodynamics"]
categories: ["engineering","design"]
---

# Summary

- My 3rd year project in University was to design a Forward Facing Step and perform wind tunnel experiments to analyse flow characteristics on that geometry using PIV.

- Particle Image Velocimetry is a practical tool for Aerodynamics analyse flow fields without intrusions in the wind tunnel environment such as sensors or pitot probes.

- In this experiment the height of the boundary layer is similarly proportioned to the height of the step. In results shown below you will notice two distinct separation regions on the aerofoil. One at the bottom of the step due to the sudden adverse pressure gradient. And another at the top of the step as the flow is unable to sharply turn the corner.

[Link to dissertation](https://drive.google.com/file/d/1jDI40Nh-rvW2NaWesEU0GMw8Fhbb6ypA/view)

[Link to PIV Python Code For Results Post Processing](https://github.com/Filpill/ffs_pivAero)


# Experimental Procedure

### Wind Tunnel Experiment

- The experimental procedure involves diffusing small oil droplets into the freestream flow and having a sheet of laser light illuminating a cross-section of the airflow. Hundreds of images are caputured in the process a high speed camera. Due to the limited field of vision, the results from the top and bottom of the step were recorded seperately.

### Image Post-Processing

- Images need some further preparation to enable reliable PIV results. Usually this involves enhancing contrast of the images to make the particles visible. Additionally any background noise picked up by the camera needs to be subtracted from the image as we want to isolate the airflow as much as possible.

### OpenPIV and Python Post-Process Scripts

- Particle displacements on the images can be determined by performing a cross-corrleation on the series of image pairs. In my case, I used OpenPIV software written in Python to extract all the velocity fields at all the times steps recorded.  Additionally, I've written some post-processing scripts for the velocity data text files in Python to animate experimental results. (I used MATLAB equivalents for my dissertation at the time of the project).

# Experimental Arangement

- Illustration of camera and laser positioning to capture wind tunnel data.
- Raw wind tunnel image with imageJ enhancements - Capturing illuminated particles moving over step within laser plane.

{{< img720 src = "/img/piv/ffs-setup.png" >}}
{{< img720 src = "/img/piv/ffs-raw.png" >}}

# Particle Image Velocimetry Results

## Instantaneous Velocity Streamplot

### Front Step
{{< img720 src = "/img/piv/piv-front-streamplot.gif" >}}

### Top Step
{{< img720 src = "/img/piv/piv-rear-streamplot.gif" >}}

## Time Averaged Velocity Contours

### Front Step
{{< img720 src = "/img/piv/piv-front-vel-results.gif" >}}

### Top Step
{{< img720 src = "/img/piv/piv-rear-vel-results.gif" >}}

## Turbulence Intensity Contours

### Front Step
{{< img720 src = "/img/piv/piv-front-turb-results.gif" >}}

### Top Step
{{< img720 src = "/img/piv/piv-rear-turb-results.gif" >}}
