/**
 * Parameterize: Chair
 * from Form+Code in Design, Art, and Architecture 
 * by Casey Reas, Chandler McWilliams, and LUST
 * Princeton Architectural Press, 2010
 * ISBN 9781568989372
 * 
 * Modified by Andreas Refsgaard to recive 5 continous values between 0.0-1.0 from Wekinator
 */

import oscP5.*;
OscP5 oscP5;

float chairSeatHeight, rawSeatHeight = 150;
float chairWidth, rawWidth = 150;
float chairDepth, rawDepth = 150;
float chairBackHeight, rawBackHeight = 150;
float chairFrameThickness, rawFrameThickness = 10;

float lerpFactor = 0.15; //Set between 0.0 (full smoothing) and 0.99 (no smoothing)

void setup() {
  size(1024, 768, P3D);
  oscP5 = new OscP5(this, 12000);

  fill(0);
  stroke(255);
}

void draw() {
  background(0);
  ortho();

  pushMatrix();
  translate(250, 100);
  rotateX(-PI / 9);
  rotateY(PI / 8);
  drawChair();
  popMatrix();
}

void drawChair() {
  // Back
  pushMatrix();
  translate(chairWidth/2, chairBackHeight/2);
  box(chairWidth, chairBackHeight, chairFrameThickness);
  popMatrix();

  // Seat
  pushMatrix();
  translate(chairWidth/2, chairBackHeight + chairFrameThickness/2, chairDepth/2 - chairFrameThickness/2);
  box(chairWidth, chairFrameThickness, chairDepth);
  popMatrix();

  // Legs
  pushMatrix();
  translate(chairFrameThickness/2, chairBackHeight + chairSeatHeight/2 + chairFrameThickness, 0);
  box(chairFrameThickness, chairSeatHeight, chairFrameThickness);
  popMatrix();

  pushMatrix();
  translate(chairWidth - chairFrameThickness/2, chairBackHeight + chairSeatHeight/2 + chairFrameThickness, 0);
  box(chairFrameThickness, chairSeatHeight, chairFrameThickness);
  popMatrix();

  pushMatrix();
  translate(chairWidth - chairFrameThickness/2, chairBackHeight + chairSeatHeight/2 + chairFrameThickness, chairDepth - chairFrameThickness);
  box(chairFrameThickness, chairSeatHeight, chairFrameThickness);
  popMatrix();

  pushMatrix();
  translate(chairFrameThickness/2, chairBackHeight + chairSeatHeight/2 + chairFrameThickness, chairDepth - chairFrameThickness);
  box(chairFrameThickness, chairSeatHeight, chairFrameThickness);
  popMatrix();

  //Lerp the values
  chairSeatHeight = lerp(chairSeatHeight, rawSeatHeight, lerpFactor);
  chairWidth = lerp(chairWidth, rawWidth, lerpFactor);
  chairDepth = lerp(chairDepth, rawDepth, lerpFactor);
  chairBackHeight = lerp(chairBackHeight, rawBackHeight, lerpFactor);
  chairFrameThickness = lerp(chairFrameThickness, rawFrameThickness, lerpFactor);
}


void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/wek/outputs")==true) {
    if (theOscMessage.checkTypetag("fffff")) { // looking for 5 parameters
      rawSeatHeight = map(theOscMessage.get(0).floatValue(), 0, 1, 10, 300);
      rawWidth = map(theOscMessage.get(1).floatValue(), 0, 1, 10, 300);
      rawDepth = map(theOscMessage.get(2).floatValue(), 0, 1, 10, 300);
      rawBackHeight = map(theOscMessage.get(3).floatValue(), 0, 1, 10, 300);
      rawFrameThickness = map(theOscMessage.get(4).floatValue(), 0, 1, 1, 50);
    } else {
      println("Error: unexpected OSC message received by Processing: ");
      theOscMessage.print();
    }
  }
}