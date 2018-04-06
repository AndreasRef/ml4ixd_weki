/*
Simple input sketch for Wekinator that sends 3 values: 
x-position, y-postion and width of the biggest detected face in the webcam feed
Requires these libraries: openCV for Processing + Video 
*/

import oscP5.*;
import netP5.*;
import gab.opencv.*;
import processing.video.*;
import java.awt.*;

OscP5 oscP5;
NetAddress dest;
 
Capture video;
OpenCV opencv;
 
int biggestFace; 
int minFaceSize = 10000;
 
int x, y, w;
 
void setup() {
  size(640, 480);
  oscP5 = new OscP5(this,9000);
  dest = new NetAddress("127.0.0.1",6448);
  video = new Capture(this, 640, 480);
 
  opencv = new OpenCV(this, 640, 480);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
 
  video.start();
}
 
void draw() {
  biggestFace = -1;
  int biggestFaceArea = 0;
  opencv.loadImage(video);
  image(video, 0, 0 );
 
  noFill();
  stroke(255, 255, 0);
  strokeWeight(3);
  Rectangle[] faces = opencv.detect();
 
  for (int i = 0; i < faces.length; i++) { //find the biggest face
    if (faces[i].width * faces[i].height > biggestFaceArea && faces[i].width * faces[i].height > minFaceSize) {
      biggestFaceArea = faces[i].width * faces[i].height;
      biggestFace = i;
      println(faces[i].width * faces[i].height);
    }
    rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
  }
  
  if (biggestFace > -1) {
    stroke(0,255,0);
    rect(faces[biggestFace].x, faces[biggestFace].y, faces[biggestFace].width, faces[biggestFace].height);
    
    x = faces[biggestFace].x;
    y = faces[biggestFace].y;
    w = faces[biggestFace].width;
    
    sendOsc();
  } 
}
 
void captureEvent(Capture c) {
  c.read();
} 
 
void sendOsc() {
  OscMessage msg = new OscMessage("/wek/inputs");
  msg.add((float)x); 
  msg.add((float)y);
  msg.add((float)w);
  oscP5.send(msg, dest);
}