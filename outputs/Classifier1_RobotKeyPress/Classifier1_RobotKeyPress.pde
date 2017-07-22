/* Wekinator->RobotKeyPress - Triggers keyboard presses on your computer! 
 
 Can be used to play games like:
 
 Wolfenstein:  http://3d.wolfenstein.com/game_EU.php 
 Controls: Left, Right, Up, X, Space
 Suggested delay time: 50?
 
 Tetris: http://www.freetetris.org/game.php
 Controls: Left, Right, X
 Delay time: 50?
 
 Google T-Rex Game: http://apps.thecodepost.org/trex/trex.html SPACE 
 Controls: Space
 Delay time: 100
 */

//Necessary for OSC communication with Wekinator:
import oscP5.*;
OscP5 oscP5;

import java.awt.AWTException;
import java.awt.Robot;
import java.awt.event.KeyEvent;

Robot robot;

boolean singleTrigger = true;
int delayTime = 100;
int lastClass = 0;
int currentClass = 0;


void setup() {
  size(400, 400);

  oscP5 = new OscP5(this, 12000);

  //Let's get a Robot...
  try { 
    robot = new Robot();
  } 
  catch (AWTException e) {
    e.printStackTrace();
    exit();
  }
}

void draw() {
  background(255);
  fill(0);
  text("Receives 1 classifier output message from wekinator", 10, 10);
  text("Listening for OSC message /wek/outputs, port 12000", 10, 30);
  text("last message: " + currentClass, 10, 180);
}


void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/wek/outputs") == true) {
    currentClass = (int) theOscMessage.get(0).floatValue();
    if (currentClass != lastClass) { //Only trig if current class is different from last class

      if (currentClass == 1) { 
        //DO NOTHING (neutral class)
      }

      if (currentClass == 2) {
        println("X");
        robot.keyPress(KeyEvent.VK_X);
        delay(delayTime);
        robot.keyRelease(KeyEvent.VK_X);
      }

      if (currentClass == 3) {
        println("LEFT");
        robot.keyPress(KeyEvent.VK_LEFT);
        delay(delayTime);
        robot.keyRelease(KeyEvent.VK_LEFT);
      }

      if (currentClass == 4) {
        println("RIGHT");
        robot.keyPress(KeyEvent.VK_RIGHT);
        delay(delayTime);
        robot.keyRelease(KeyEvent.VK_RIGHT);
      }

      if (currentClass == 5) {
        println("UP");
        robot.keyPress(KeyEvent.VK_UP);
        delay(50);
        robot.keyRelease(KeyEvent.VK_UP);
      }

      if (currentClass == 6) {
        println("SPACE");
        robot.keyPress(KeyEvent.VK_SPACE);
        delay(delayTime);
        robot.keyRelease(KeyEvent.VK_SPACE);
      }
    }
    lastClass = currentClass;
  }
}