---
title: "2D Heat Transfer Simulation"
date: 2021-07-10
draft: false

cover:
  image : img/ht/bc.png
  alt: 'Boundary Conditions'

tags: ["python","matlab","thermodynamics","simulation","programming"]
categories: ["engineering"]
---

## Summary

- Re-writing 2D heat transfer simulation designed in MATLAB to Python.
- Solved using Successive Over Relaxation Algorithm and Finite Difference Method used to capture incremental changes of temeperature on grid.
- Animated the heat transitions in Python at each timestep using FuncAnimation component of matplotlib.
- LHS boundaries on the mesh and the application of the heat input on the leftmost nodes.
- Heat Input lasts 2 seconds in resulting simulation before being turned off.

[Link to Heat Transfer Project](https://github.com/Filpill/2D_HeatTranfer)

{{< img720 src = "/img/ht/2d-ht.gif" >}}
