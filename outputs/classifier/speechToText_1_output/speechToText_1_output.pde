import oscP5.*;
import guru.ttslib.*;

TTS tts;
OscP5 oscP5;
int currentClass; 
int lastClass; 

void setup() {
  size(600, 400);
  oscP5 = new OscP5(this, 12000);
  tts = new TTS();
}

void draw() {
  background(0);
  textSize(64);
  text(currentClass, width/2, height/2);
  
  if (currentClass == 1 && currentClass != lastClass) {
    tts.speak("Class one");
  } else if (currentClass == 2 && currentClass != lastClass) {
    tts.speak("Class two");
  } else {
    //Else do this
  }
  lastClass = currentClass;
}

void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/wek/outputs") == true) {
    currentClass = (int) theOscMessage.get(0).floatValue();
  }
}