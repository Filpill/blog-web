---
title: "Servo Turret Control"
description: "Writing Arduino and Python software to control servo turret using mouse inputs"
date: 2023-07-03
hideSummary: true
ShowWordCount: true
ShowReadingTime: true
ShowToC: true
draft: false

cover:
  image : img/servoTurret/mouse_setup.jpg
  alt: 'Solidworks Render of Tractor'

categories: [Electronics]
---

## Summary 

This project has been made to practise the use of sending instructions to various electronics for both the Arduino and the Raspberry Pi.

I've segmented this project into two parts/versions:
- Arduino - Mouse Control via Serial Communications Port
- Raspberry Pi - Mouse Control via Python Tkinter Program

![Link to Project for Mouse Controlled Servo](https://github.com/Filpill/mouseServo)

## Arduino 

The arduino project is very simple, there is a program written in Processing which takes the mouse inputs send strings (enclosed in <>) to the Arduino via serial communications. 

A small delay of 100ms is maintained to limit the rate of data coming to the Arduino board. The Arduino has a small serial buffer, it can only read 8 bytes at a time. Therefore we need to limit the rate of data to prevent a serial buffer overflow. If this issue occurs, then the servo will not be able to effectively read the data stream.

The Arduino has a sketch uploaded to the board that will do a number operations. 
- It will ingest the string data character by character from '<' and terminate at '>'.
- It will concatenate all the characters into a single string.
- Split the string to serve as inputs to its respective components i.e. Servo1 and Servo2
- The inputs will be converted to integers to map the angle for the Servos.
- Actuate the Servos


{{< img720 src = "img/servo/mouse.gif" >}}

{{<mermaid>}}
graph TD;
    subgraph Processing Program
    P0([Start Processing GUI Program])--> P1[Mouse Inputs -- Pitch/Yaw]
    P1 --> P2[Formulate Data String <000000> and send over COM Port]
    end

    subgraph Arduino Program
    P2-->A0[Read Data Stream]
    A0-->A1[Start Ingesting the data after reading '<' character]
    A1-->A2[Build string by ingesting characters one at a time]
    A2-->A3[Terminate the string when reading '>']
    A3-->A4[Split string into respective components to prep servo inputs]
    A4-->A5[Cast servo inputs to integers and map servo angles]
    A5-->A0
    end

    subgraph Arduino Program
    A5-->S1([Actuate Yaw Servo])
    A5-->S2([Actuate Pitch Servo])
    end
{{< /mermaid >}}

## Raspberry Pi 


The Raspberry Pi project is using a Python script to drive the inputs. I've created a Tkinter program which maps the mouse position on the GUI to a pair of servo angles for the turret to move.

The mouse movements are passed into an event handler to locate mouse position on the window x,y coordinates. We use positional data on the mouse to calculate a servo angle based on the coordinate on the drawn window.

In order to actuate the servos, the angle inputs must be mapped to the corresponding duty cycle. The duty cycle can take any range of values between 2 and 12 for this particular servo. It handles angles in the range between 0 and 180 degrees.

The duty cycle can be calculated like with this calculation:

```
1/18 * angle + 2
```

Then we send the pair of updated duty cycle values to the respective GPIO pins in order to drive the servo positions.

{{< img720 src = "img/servo/tkinter_pi_ui_animation.gif" >}}

{{< img720 src = "img/servo/servo_pi_control.gif" >}}

{{<mermaid>}}
graph TD;
    subgraph Python Program
    P0([Run Python])--> P1([Start Tkinter GUI])
    P0 --Initialise--> G0[GPIO Pins]
    P1 --> P2[Mouse Movements Passed to Event Handler]
    P2 --> P3[Convert X,Y Coordinates to Servo Angles]
    P3 --> P4[Map Servo Angles to Duty Cycle Values]
    P4 --> P5[Send Duty Cycle Values Through GPIO Pins]
    P5 --> G0
    G0 --> S1([Actuate Yaw Servo])
    G0 --> S2([Actuate Pitch Servo])
    end

{{< /mermaid >}}
