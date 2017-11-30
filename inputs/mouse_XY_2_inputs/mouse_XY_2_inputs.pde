//Modified from https://github.com/fiebrink1/wekinator_examples/blob/master/inputs/Processing/Simple_MouseXY_2Inputs/Simple_MouseXY_2Inputs.pde
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress dest;

void setup() {
  size(600, 400);
  oscP5 = new OscP5(this,9000);
  dest = new NetAddress("127.0.0.1",6448);
}

void draw() {
  background(0);
  if(mousePressed) {
    sendOsc();
    text("sending!", 520, 30);
  }
  text("Send mouse x and y position (2 inputs) to Wekinator when mouse is pressed", 10, 30);
  text("x=" + mouseX + ", y=" + mouseY, 10, 80);
  
  ellipse(mouseX, mouseY, 10, 10);
}

void sendOsc() {
  OscMessage msg = new OscMessage("/wek/inputs");
  msg.add((float)mouseX); 
  msg.add((float)mouseY);
  oscP5.send(msg, dest);
}