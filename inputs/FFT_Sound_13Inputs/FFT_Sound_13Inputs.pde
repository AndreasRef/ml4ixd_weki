import ddf.minim.*;
import ddf.minim.analysis.*;

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress dest;


Minim       minim;
//AudioPlayer myAudio;
AudioInput  myAudio; //Use líne in input (microphone/soundflower/lineIn)
FFT         myAudioFFT;

int         myAudioRange     = 13;
int         myAudioMax       = 100;
float       myAudioAmp       = 200.0;
float       myAudioIndex     = 0.2;
float       myAudioIndexAmp  = myAudioIndex;
float       myAudioIndexStep = 0.35;

void setup() {
  size(850, 300);
  background(200);

  minim   = new Minim(this);
  myAudio = minim.getLineIn(Minim.MONO);  //Use líne in input (microphone/soundflower/lineIn)

  //myAudio = minim.loadFile("../../musicFiles/HecQ.mp3"); //Use a music file
  //myAudio.loop(); //Use a music file

  myAudioFFT = new FFT(myAudio.bufferSize(), myAudio.sampleRate());
  myAudioFFT.linAverages(myAudioRange);
  myAudioFFT.window(FFT.GAUSS);
  
    /* start oscP5, listening for incoming messages at port 9000 */
  oscP5 = new OscP5(this,9000);
  dest = new NetAddress("127.0.0.1",6448);
}

void draw() {
  background(100);

  myAudioFFT.forward(myAudio.mix);

  for (int i = 0; i < myAudioRange; ++i) {
    stroke(0);
    fill(255);
    float tempIndexAvg = (myAudioFFT.getAvg(i) * myAudioAmp) * myAudioIndexAmp;
    float tempIndexCon = constrain(tempIndexAvg, 0, myAudioMax);
    rect( 100 + (i*50), 100, 50, tempIndexCon);
  }
  myAudioIndexAmp = myAudioIndex;

  stroke(255,0,0); 
  line(100, 100+100, width-100, 100+100);
  
  sendOsc();
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
    //float tempIndexCon = constrain(tempIndexAvg, 0, myAudioMax);
    msg.add(tempIndexAvg);
  }
 oscP5.send(msg, dest);
}