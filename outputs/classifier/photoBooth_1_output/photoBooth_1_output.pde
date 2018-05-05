//Basic sketch showing the basics of building a conditional photo booth for Processing with a input from Wekinator
//Train Wekinator in classification mode with two classes:
//Class 1 is neutral and class 2 will trigg the photo booth to take a picture. 

//www.andreasrefsgaard.dk - 2018

import processing.video.*;
import oscP5.*;
import ddf.minim.*;

Minim minim;
AudioSample sound;

OscP5 oscP5;
int currentClass; 
int lastClass;

PGraphics pg;
PImage lastSnapShot;

int timer = 0;
boolean showLatestPhoto = false;

Capture cam;

void setup() {
  size(640, 480);
  pg = createGraphics(width, height);
  oscP5 = new OscP5(this, 12000);

  minim = new Minim(this);
  sound = minim.loadSample( "shutter.wav", 512);

  String[] cameras = Capture.list();

  if (cameras == null) {
    cam = new Capture(this, 640, 480);
  } 
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    cam = new Capture(this, cameras[0]);
    cam.start();
  }
}

void draw() {
  if (cam.available() == true) {
    cam.read();
  }
  image(cam, 0, 0, width, height);

  if (showLatestPhoto && timer < 100) {
    pg.beginDraw();
    pg.image(lastSnapShot, 0, 0);
    pg.endDraw();
    image(pg, 0, 0);
  }

  if (timer < 5) {   
    background(timer*25+130);
  } else if (timer < 8) {
    background(255);
  }

  if (timer > 100) {
    showLatestPhoto = false;
  }
  timer++;
}

void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/wek/outputs") == true) {
    currentClass = (int) theOscMessage.get(0).floatValue();
  }
  if (currentClass == 2 && currentClass != lastClass) {
    saveFrame("#####" + ".jpg");
    lastSnapShot = get();
    showLatestPhoto = true;
    timer = 0;
    sound.trigger();
  }
  lastClass = currentClass;
}