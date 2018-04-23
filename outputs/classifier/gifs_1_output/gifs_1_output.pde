// ATTENTION! This sketch requires you to manually download the GifAnimation library from https://github.com/01010101/GifAnimation
// And place it in your Processing libraries folder
import gifAnimation.*; 
import oscP5.*;
OscP5 oscP5;

String[] expressions = {"NEUTRAL", "SURPRISED", "EXCITED", "SAD", "FLIRTY"};
PImage[] animation;
Gif[] reactionGifs;
int currentClass; 
int index = 0;
PFont myFont;

void setup() {
  size(800, 600);
  oscP5 = new OscP5(this, 12000);
  
  myFont = createFont("Impact", 96);
  textFont(myFont);
  textAlign(CENTER);  
  
  reactionGifs = new Gif[5];
  for (int i = 0; i<reactionGifs.length; i++) {
    reactionGifs[i] = new Gif(this, i + ".gif");
    reactionGifs[i].loop();
  }
}

void draw() {
  image(reactionGifs[index], 0, 0, width, height);
  textSize(96);
  fill(255,0,255);
  text(expressions[index], width-220 ,150); 
}


void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/wek/outputs") == true) {
      currentClass = (int) theOscMessage.get(0).floatValue();
      index = currentClass - 1;
  }
}