import oscP5.*;
OscP5 oscP5;
int currentClass; 

void setup() {
  size(600, 400);
  oscP5 = new OscP5(this, 12000);
}

void draw() {
  background(0);
  textSize(64);
  text(currentClass, width/2, height/2);
  
  if (currentClass == 1) {
    //Do something on class 1
  } else if (currentClass == 2) {
    //Do something else on class 2
  } else {
    //Else do this
  }
}

void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/wek/outputs") == true) {
    currentClass = (int) theOscMessage.get(0).floatValue();
  }
}