//Sends 1728 HOGDescriptor inputs from webcam to Wekinator. 
//Modified from https://github.com/atduskgreg/gestuRe by Andreas Refsgaard

import processing.video.*;
import controlP5.*;

import gab.opencv.*;
import org.opencv.core.Core;
import org.opencv.core.CvType;
import org.opencv.core.Mat;
import org.opencv.core.Scalar;
import org.opencv.core.TermCriteria;

import org.opencv.core.Mat;
import org.opencv.core.MatOfFloat;
import org.opencv.core.MatOfPoint;

import org.opencv.objdetect.HOGDescriptor;

import org.opencv.core.Size;
import org.opencv.core.Scalar;
import org.opencv.core.Core;

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress dest;

OpenCV opencv;
Capture video;

PImage testImage;
int rectW = 150;
int rectH = 150;

import psvm.*;
SVM model;


void setup() {
  size(320, 240);
  oscP5 = new OscP5(this,9000);
  dest = new NetAddress("127.0.0.1",6448);
  
  opencv = new OpenCV(this, 50, 50);
 
  video = new Capture(this, 320, 240);
  video.start();
  
  testImage = createImage(50, 50, RGB);
}



void draw() {  
  background(0);
  image(video, 0, 0);
  noFill();
  stroke(255, 0, 0);
  strokeWeight(5);
  rect(video.width - rectW - (video.width - rectW)/2, video.height - rectH - (video.height - rectH)/2, rectW, rectH);

  testImage.copy(video, video.width - rectW - (video.width - rectW)/2, video.height - rectH - (video.height - rectH)/2, rectW, rectH, 0, 0, 50, 50);
  sendOsc();
}


void captureEvent(Capture c) {
  c.read();
}

float[] gradientsForImage(PImage img) {
  // resize the images to a consistent size:
  opencv.loadImage(img);

  Mat angleMat, gradMat;
  Size winSize = new Size(40, 24);
  Size blockSize = new Size(8, 8);
  Size blockStride = new Size(16, 16);
  Size cellSize = new Size(2, 2);
  int nBins = 9;
  Size winStride = new Size(16, 16);
  Size padding = new Size(0, 0);

  HOGDescriptor descriptor = new HOGDescriptor(winSize, blockSize, blockStride, cellSize, nBins);

  MatOfFloat descriptors = new MatOfFloat();

  //descriptor.compute(opencv.getGray(), descriptors);
  //Size winStride, Size padding, MatOfPoint locations
  MatOfPoint locations = new MatOfPoint();
  descriptor.compute(opencv.getGray(), descriptors, winStride, padding, locations);

  return descriptors.toArray();
}

void sendOsc() {
  OscMessage msg = new OscMessage("/wek/inputs");
  
  float[] values = gradientsForImage(testImage);
  for (int i = 0; i<values.length; i++) {
   msg.add(values[i]); 
  }
  oscP5.send(msg, dest);
}