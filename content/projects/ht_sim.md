---
title: "2D Heat Transfer Simulation"
date: 2021-07-10
draft: true

cover:
  image : img/ht/2d-ht.gif
  alt: 'Heat Transfer Animation'

tags: ["python","matlab","thermodynamics","simulation","programming"]
categories: ["engineering"]
---

### Summary

- Re-writing 2D heat transfer simulation designed in MATLAB to Python.
- Solved using Successive Over Relaxation Algorithm and Finite Difference Method used to capture incremental changes of temeperature on grid.
- Animated the heat transitions in Python at each timestep using FuncAnimation component of matplotlib.


### Boundary Condition Illustration

- Visual illustration of the boundaries on the mesh and the application of the heat input on the leftmost nodes.
- Resulting heat transfer comes after a 2 second heat input on the left hand side of the plate.

![Boundary Conditions](/img/ht/bc.png)
