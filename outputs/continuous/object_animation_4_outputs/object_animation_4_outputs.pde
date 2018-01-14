//This demo allows Wekinator to control size, increment, rotation and hue of an object
//All recieved values shoulb be continuous values between 0 and 1
//Visual sketch is modified from http://btk.tillnagel.com/tutorials/rotation-translation-matrix.html

import oscP5.*;
OscP5 oscP5;

int objectSize = 400;
int increment = 10;
float rotation = 0;
float hue = 0;

void setup() {  
  size(600, 600);
  oscP5 = new OscP5(this, 12000);

  colorMode(HSB);
  rectMode(CENTER);
  stroke(30, 40);
  fill(255, 100, 50);
}

void draw () {
  background(0);
  pushMatrix();
  translate(width / 2, height / 2);
  for (int s = objectSize; s > 0; s = s - increment) {
    fill(hue, 255 - s/3, 255 - s/3);
    rotate(rotation);
    rect(0, 0, s, s);
  }
  popMatrix();
  drawText();
}

void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/wek/outputs")==true) {
    if (theOscMessage.checkTypetag("ffff")) { // looking for 4 parameters
      float receivedSize = theOscMessage.get(0).floatValue();
      float receivedIncrement = theOscMessage.get(1).floatValue();
      float receivedRot = theOscMessage.get(2).floatValue();
      float receivedHue = theOscMessage.get(3).floatValue();

      objectSize = (int) map(receivedSize, 0, 1, 25, 800);
      increment = (int) map(receivedIncrement, 0, 1, 5, 100);
      rotation = map(receivedRot, 0, 1, 0, 2*PI);
      hue = map(receivedHue, 0, 1, 0, 255);
    } else {
      println("Error: unexpected OSC message received by Processing: ");
      theOscMessage.print();
    }
  }
}

void drawText() {
    stroke(0);
    textAlign(LEFT, TOP); 
    fill(0, 0, 255);

    text("Listening for message /wek/inputs on port 12000", 10, 10);
    text("Expecting 4 continuous numeric outputs, all in range 0 to 1:", 10, 25);
    text("size, increment, rotation and hue" , 10, 40);
}