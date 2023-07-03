---
title: "Servo Turret Control"
date: 2023-07-03
draft: True
ShowToC: false

cover:
  image : img/servoTurret/mouse_setup.jpg
  alt: 'Solidworks Render of Tractor'

tags: ["design","engineering","mechanical","3d-printing","arduino","raspberry pi"]
categories: ["engineering","design"]
---

## Summary

This project has been made to practise the use of sending instructions to various electronics via serial communications.

I've segmented this project into two parts/versions:
- Arduino - Manual Control with Mouse via Serial Comms Port
- Raspberry Pi - AI Face Tracking with Python and Camera Module

## Arduino 

The arduino project is very simple, there is a program written in Processing which takes the mouse inputs send strings (enclosed in <>) to the Arduino via serial comminications. 

A small delay of 100ms is maintained to limit the rate of data coming to the Arduino board. The Arduino has a small serial buffer, so we need to limit the rate of data to prevent a serail buffer overflow. If this issue occurs, then the servo will not be able to effectively read the data stream.

The Arduino has a sketch uploaded to the board that will do a number opperations. 
- It will ingest the string data character by character from '<' and terminate at '>'.
- It will concatenate all the characters into a single string.
- Split the string to serve as inputs to its respective components i.e. Servo1 and Servo2
- The inputs will be converted to integers to map the angle for the Servos.
- Actuate the Servos


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

*To be completed*

The Raspberry Pi project is using a Python script to drive the inputs. At the moment there is a face-detection algorithm to create the inputs.

I'm using the Haar cascade model in the OpenCV library to provide my facial detection.

I will report back when the inputs have been implemented using the Raspberry Pi.

## Gifs


{{< img720 src = "img/servoTurret/mouse.gif" >}}
