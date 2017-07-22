import ddf.minim.*;
import oscP5.*;
import netP5.*;
OscP5 oscP5;

Minim minim;

AudioSample[] sounds;

int lastClass = 0;
int currentClass = 0;

void setup()
{
  size(600, 400);
  minim = new Minim(this);
  oscP5 = new OscP5(this, 12000);
  
  sounds = new AudioSample[4];
  sounds[0] = minim.loadSample( "BD.mp3", 512);
  sounds[1] = minim.loadSample( "SD.wav", 512);
  sounds[2] = minim.loadSample( "Suspense1.wav", 512);
  sounds[3] = minim.loadSample( "Suspense2.wav", 512);
}

void draw()
{
  background(0);
  textSize(64);
  text(currentClass, width/2, height/2);
}

void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/wek/outputs") == true) {
      currentClass = (int) theOscMessage.get(0).floatValue();
      if (currentClass != lastClass) { //Only trig if current class is different from last class
        if (currentClass == 1) sounds[0].trigger();
        if (currentClass == 2) sounds[1].trigger();
        if (currentClass == 3) sounds[2].trigger();
        if (currentClass == 4) sounds[3].trigger();
      }
      lastClass = currentClass;
  }
}