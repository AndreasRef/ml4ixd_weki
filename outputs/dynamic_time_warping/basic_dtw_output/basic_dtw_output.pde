// Simplified example by Andreas Refsgaard showing how to recieve outputs from Wekinator using DTW 
// Receives DTW commands /output_1, /output_2, /output_3 (the default messages for 1st 3 gestures) on port 12000 */

import oscP5.*;

OscP5 oscP5;

int lastOutput = 0;

void setup() {
  oscP5 = new OscP5(this, 12000); //listen for OSC messages on port 12000 (Wekinator default)
  size(400, 300);
}
void draw() {
  background(0);
  text(lastOutput, width/2, height/2);
}

void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/output_1")==true) {
    println("output_1");
    lastOutput = 1;
  } else if (theOscMessage.checkAddrPattern("/output_2")==true) {
    println("output_2");
    lastOutput = 2;
  } else if (theOscMessage.checkAddrPattern("/output_3") == true) {
    println("output_3");
    lastOutput = 3;
  } else {
    println("Unknown OSC message received");
  }
}

void drawText() {
  text( "Receives /output_1 /output_2 /output_3 (default messages) from Wekinator", 5, 15 );
  text( "Receives on port 12000", 5, 30 );
}