// This sketch requires you to manually download the GifAnimation library from https://github.com/01010101/GifAnimation
// And place it in your Processing libraries folder
import gifAnimation.*; 
import oscP5.*;
OscP5 oscP5;

String[] expressions = {"NEUTRAL", "SURPRISED", "EXCITED", "SAD", "FLIRTY"};
PImage[] animation;
PImage bg;
Gif[] reactionGifs;
int currentClass; 
int index = 0;
PFont myFont;

public void setup() {
  size(1000, 800);
  frameRate(100);
  oscP5 = new OscP5(this, 12000);
  
  myFont = createFont("Impact", 96);
  textFont(myFont);
  textAlign(CENTER);  
  
  reactionGifs = new Gif[5];
  for (int i = 0; i<reactionGifs.length; i++) {
    reactionGifs[i] = new Gif(this, i + ".gif");
    reactionGifs[i].loop();
  }
  bg = loadImage("bg.png");
}

void draw() {
  background(bg);
  image(reactionGifs[index], 0, 0, width, height - 200);
  
  stroke(0,255,0);
  strokeWeight(5);
  noFill();
  rect(index*200, height-200, 200, 200);
  
  fill(0,255,0);
  textSize(48);
  text("Current expression:", width-220 ,50);
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