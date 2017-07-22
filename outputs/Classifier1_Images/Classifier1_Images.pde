import oscP5.*;
OscP5 oscP5;
int currentClass; 
PImage[] imgs;
int index = 0;

void setup() {
  size(600, 400);
  oscP5 = new OscP5(this, 12000);
  
  imgs = new PImage[2];
  imgs[0] = loadImage("0.jpg");
  imgs[1] = loadImage("1.jpg");
}

void draw() {
  background(255);
  image(imgs[index], 0, 0, width, height);
}


void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/wek/outputs") == true) {
    currentClass = (int) theOscMessage.get(0).floatValue();
    index = currentClass - 1;
  }
}