---
title: "3D Printed Car - Bluetooth Controller Interface"
date: 2021-10-21
draft: false
ShowToC: true

cover:
  image : img/3dcar/iso-render.png
  alt: 'Isometric View Car'

tags: ["design","engineering","mechanical","automotive","bluetooth","processing3","3d-printing","programming","mechatronics"]
categories: ["engineering","design"]
---

# Summary


- Personal project to design and build a 3D printed car from scratch.
- Project status is currently dormant as I haven't had time to iterate over the design due to the complexity and required time investment.
	- The project was gradually being built over the course of 2020 and 2021.
	- Though incomplete, I may return to this project at a later stage (with a smaller scope) after finishing some other projects.
	- The project requires some simplification for the desired goal of having a robust car design.
- I will share the existing highlights of this projects for the time being.


 [Link to Project Document Discussing Changes From V1 to V2 on Google Drive](https://drive.google.com/file/d/1EldK84WdVEGBc5a2cYDj4144Esv3kpME/view)

 [Link to programming of control loop for 3D Printed Car](https://github.com/Filpill/BTCarController)

# Solidworks Design

## Side View

{{< img720 src = "/img/3dcar/side.png" >}}

## Back View

{{< img720 src = "/img/3dcar/back.png" >}}

## Isometric View

{{< img720 src = "/img/3dcar/isometric.png" >}}

# Programming


## Processing3 Controller Program - Bluetooth Interface

```{C}
import processing.serial.*;
import controlP5.*;
Serial myPort;
ControlP5 cp5;

//Initialising Global Variables
int Motor_Speed = 0;
int Steering = 0;
int Forward = 0;
int Backward = 0;
String angleStatus;

void setup() {

//Inserting Controller Buttons and Sliders

size(450,500);
cp5 = new ControlP5(this);
cp5.addSlider("Steering").setPosition(50,150).  setSize(200, 100). setRange(0,255);
cp5.addSlider("Motor_Speed").setPosition(50,275).  setSize(175, 100). setRange(0,205);
cp5.addButton("Forward").setValue(205).setPosition(300,150).setSize(100,100);
cp5.addButton("Backward").setValue(205).setPosition(300,275).setSize(100,100);

//Initialising Bluetooth Communication

myPort = new Serial(this, "COM3", 9600); // Starts the serial communication at 9600 baud rate
myPort.bufferUntil('\n');// Reading Serial Data up to new line. The character '\n' or 'New Line'
}

void serialEvent (Serial myPort){// Checks for available data in the Serial Port
angleStatus = myPort.readStringUntil('\n');//Reads the data sent from the Arduino
}

void draw (){

//Drawing Title and Backround of Controller
  background(20,150,200);
  fill(120,170,220);
  rect(10,10,425,50);
  fill(0);
  textSize(23);
  text("RC Car Bluetooth Controller Interface",15,45);

  //Defining RC Car Parameters 000-000-0
  //000-xxx-x = Steering
  //xxx-000-x = Motor Speed
  //xxx-xxx-0 = Motor ON/OFF

//String needs to be defined inside the draw function to keep updating strings
String sfSteering = nf(Steering,3);       //3-digit steering value
String sfMotor_Speed = nf(Motor_Speed,3); //3-digit motor-speed value


if(mousePressed&& mouseX>300 && mouseX<400 && mouseY>150 && mouseY<250){
       println('<'+sfSteering + sfMotor_Speed + "1"+'>');
       myPort.write('<'+sfSteering + sfMotor_Speed + "1"+'>'); delay(100);} //Send Go FWD String to Arduino

else if(mousePressed&& mouseX>300 && mouseX<400 && mouseY>275 && mouseY<375){
       println('<'+sfSteering + sfMotor_Speed + "2"+'>');

       myPort.write('<'+sfSteering + sfMotor_Speed + "2"+'>'); delay(100);} //Send Go BCK String to Arduino
     else{
       println('<'+sfSteering + sfMotor_Speed + "0"+'>');

       myPort.write('<'+sfSteering + sfMotor_Speed + "0"+'>'); delay(100);} //Send STOP String to Arduino

}
```


## Arduino Control Loop

```{C}
#include <Servo.h>

//for reading characters in

const byte numChars = 32;
char receivedChars[numChars];

boolean newData = false;

//Inititalise Servo
Servo myServo;

//Define Motor H-Bridge Parameters
int In1 = 7;
int In2 = 8;
int ENA = 5;

//Define variables for incoming bluetooth data
long tmr;
int flag = 0;
String RCSteer;
String RCMotorSpeed;
String Motor_Polarity;
int RCSteer_Int ;
int RCMotorSpeed_Int;
int Motor_Polarity_Int;
int angle;
char  c;

void setup() {

  //Inialise Servo Data Pin
  myServo.attach(3);

  //Initialise H-Bridge Pins Data Output
  pinMode (In1, OUTPUT);
  pinMode (In2, OUTPUT);
  pinMode (ENA, OUTPUT);

  //Initialise Bluetooth Serial communication + Serial Interupt Signal
  Serial.begin(9600);
  delay(100);
}

void loop() {

  //Read Strings into Arduino
    recvWithStartEndMarkers();
    showNewData();

     //Convert Character Array to String Object
    String RCString = receivedChars;

    //Extract Control Components
    RCSteer = RCString.substring(0, 3);
    RCMotorSpeed = RCString.substring(3, 6);
    Motor_Polarity = RCString.substring(6, 7);

    //Convert Strings to Integers
    RCSteer_Int = RCSteer.toInt();
    RCMotorSpeed_Int = RCMotorSpeed.toInt();
    Motor_Polarity_Int = Motor_Polarity.toInt();

    //Print data to Serial Monitor
    Serial.print("RCcode:  ");
    Serial.print(receivedChars);
    Serial.print("  Steering Value:  ");
    Serial.print(RCSteer_Int);
    Serial.print("  ANGLE:  ");
    Serial.print(angle);
    Serial.print("  Speed Value:  ");
    Serial.print(RCMotorSpeed_Int);
    Serial.print("  Polarity Value:  ");
    Serial.println(Motor_Polarity_Int);

    //Calling Steer and MotorControl Functions
    Steer(RCSteer_Int);
    MotorControl(Motor_Polarity_Int,RCMotorSpeed_Int);

  }

void Steer(int RCSteer_Int){
  //Send Steering Data to Servo
  angle = map(RCSteer_Int, 0, 255, 0, 180);
  myServo.write(angle);
}

void MotorControl(int Motor_Polarity_Int, int RCMotorSpeed_Int){

    //Motor Logic
    switch(Motor_Polarity_Int){

    // FORWARDS
    case 1:
      analogWrite(ENA, RCMotorSpeed_Int);
      digitalWrite(In1, HIGH);
      digitalWrite(In2, LOW);
    break;

    // BACKWARDS
    case 2:
      analogWrite(ENA, RCMotorSpeed_Int);
      digitalWrite(In1, LOW);
      digitalWrite(In2, HIGH);
    break;

    // STOP
    case 0:
    digitalWrite(In1, LOW);
    digitalWrite(In2, LOW);
    break;
    }
}
void recvWithStartEndMarkers() {
    static boolean recvInProgress = false;
    static byte ndx = 0;
    char startMarker = '<';
    char endMarker = '>';
    char rc;

    while (Serial.available() > 0 && newData == false) {
        rc = Serial.read();

        if (recvInProgress == true) {
            if (rc != endMarker) {
                receivedChars[ndx] = rc;
                ndx++;
                if (ndx >= numChars) {
                    ndx = numChars - 1;
                }
            }
            else {
                receivedChars[ndx] = '\0'; // terminate the string
                recvInProgress = false;
                ndx = 0;
                newData = true;
            }
        }

        else if (rc == startMarker) {
            recvInProgress = true;
        }
    }
}

void showNewData() {
    if (newData == true ){
        newData = false;
    }
}
```
