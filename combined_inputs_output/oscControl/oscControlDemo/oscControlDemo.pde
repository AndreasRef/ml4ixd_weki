//http://www.wekinator.org/detailed-instructions/#Controlling_Wekinator_via_OSC_messages

//Simple sketch showing how to remotely control Wekinator via OSC messages

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress dest;

void setup() {
  size(500, 200);
  oscP5 = new OscP5(this, 9000);
  dest = new NetAddress("127.0.0.1", 6448);
}

void draw() {
  background(0);
  
  text("Simple sketch showing how to remotely control Wekinator via OSC messages", 20, 20);
  
  text("Press '1' or '2' to set the outputs in Wekinator", 20, 60);
  text("Press 'r' to start recording", 20, 80);
  text("Press 's' to stop recording", 20, 100);
  
}

void keyPressed() {
  if (key == '1') {
    OscMessage msg = new OscMessage("/wekinator/control/outputs");
    msg.add(1.0); 
    oscP5.send(msg, dest); 
  } else if (key == '2') {
    OscMessage msg = new OscMessage("/wekinator/control/outputs");
    msg.add(2.0); 
    oscP5.send(msg, dest);
  } else if (key == 'r') {
    OscMessage msg = new OscMessage("/wekinator/control/startRecording");
    oscP5.send(msg, dest);
  } else if (key == 's') {
    OscMessage msg = new OscMessage("/wekinator/control/stopRecording");
    oscP5.send(msg, dest);
  }
} 