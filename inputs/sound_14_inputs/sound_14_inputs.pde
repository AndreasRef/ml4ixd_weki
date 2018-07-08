//Messy FFT sound input alternative to Wekinator - will clean it later. Decent enough for prototyping, but consider using something like 
//https://github.com/fiebrink1/wekinator_examples/tree/master/inputs/AudioInput/AudioInputWithOpenFrameworks/Various_Audio_Inputs
//for better results.

//Change volThreshold according to the loudness of the sounds you want to use as training input
//Change the boolean triggerMode to false to send sound information at all times


import ddf.minim.*;
import ddf.minim.analysis.*;

import oscP5.*;
import netP5.*;
import controlP5.*;

ControlP5 cp5;

OscP5 oscP5;
NetAddress dest;

Minim       minim;
AudioInput  myAudio; //Use líne in input (microphone/soundflower/lineIn)
FFT         myAudioFFT;

int         myAudioRange     = 13;
int         myAudioMax       = 100;
float       myAudioAmp       = 200.0;
float       myAudioIndex     = 0.2;
float       myAudioIndexAmp  = myAudioIndex;
float       myAudioIndexStep = 0.35;

float avgVolume = 0;

boolean sending = false;
color bgColor; 
boolean thresholdMode = true;
float volThreshold = 2.0;

boolean triggerMode = false;

int triggerTimerThreshold = 500;
long startTimer = 0;

void setup() {
  size(850, 300);
  background(200);
  
  cp5 = new ControlP5(this);
  cp5.addToggle("triggerMode").linebreak();
  cp5.addSlider("volThreshold",0.0,10.0);
  

  minim   = new Minim(this);
  myAudio = minim.getLineIn(Minim.MONO); 
  myAudioFFT = new FFT(myAudio.bufferSize(), myAudio.sampleRate());
  myAudioFFT.linAverages(myAudioRange);
  myAudioFFT.window(FFT.GAUSS);
  
  oscP5 = new OscP5(this,9000);
  dest = new NetAddress("127.0.0.1",6448);
}

void draw() {
  long timer = millis() - startTimer;
  
  if (sending == true) {
    bgColor = color(0,180,0);
  } else {
    bgColor = color(180, 0, 0);
  }
  background(bgColor);

  myAudioFFT.forward(myAudio.mix);

  for (int i = 0; i < myAudioRange; ++i) {
    stroke(0);
    fill(255);
    float tempIndexAvg = (myAudioFFT.getAvg(i) * myAudioAmp) * myAudioIndexAmp;
    float tempIndexCon = constrain(tempIndexAvg, 0, myAudioMax);
    rect( 100 + (i*50), 100, 50, tempIndexCon);
    avgVolume+=tempIndexAvg;
  }
  
  avgVolume = avgVolume/12;
  
 if (triggerMode) {
  if (timer > triggerTimerThreshold && avgVolume > volThreshold) { 
    sending = true;
    startTimer = millis();
  } else {
    sending = false; 
  }
 } else {
   sending = true;
 }
  
  text("avgVolume: " + avgVolume, 10, height - 60);
  if (sending) text("sending!", 10, height - 30);
  
  myAudioIndexAmp = myAudioIndex;

  stroke(255,0,0); 
  line(100, 100+100, width-100, 100+100);
  
  if(sending) sendOsc();
}

void stop() {
  myAudio.close();
  minim.stop();  
  super.stop();
}

void sendOsc() {
  OscMessage msg = new OscMessage("/wek/inputs");
  for (int i = 0; i < myAudioRange; ++i) {
    float tempIndexAvg = (myAudioFFT.getAvg(i) * myAudioAmp) * myAudioIndexAmp;
    msg.add(tempIndexAvg);
  }
  msg.add(avgVolume);
  
 oscP5.send(msg, dest);
}