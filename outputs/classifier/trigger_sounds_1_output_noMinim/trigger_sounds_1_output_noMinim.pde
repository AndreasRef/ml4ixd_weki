import processing.sound.*;
import oscP5.*;
import netP5.*;
OscP5 oscP5;


SoundFile[] sounds;

//AudioSample[] sounds;

int lastClass = 0;
int currentClass = 0;

void setup()
{
  size(600, 400);
  
  oscP5 = new OscP5(this, 12000);

  sounds = new SoundFile[5];  
  
  
  for (int i = 0; i< sounds.length; i++) {
    
    sounds[i] = new SoundFile(this, i + ".mp3");
    
  }
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
      for (int i = 1; i<=sounds.length; i++) {
        //if (currentClass == i) sounds[i-1].trigger();
        if (currentClass == i) {
        sounds[i-1].play();
        } else {
        sounds[i-1].stop();
        }
        
      }
    }
    lastClass = currentClass;
  }
}
