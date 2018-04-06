// Tweaked by Andreas Refsgaard 2018 to work with Processing 3 and the newest openkinect library

// Rebecca Fiebrink
// www.cs.princeton.edu/~fiebrink/
// Example of using Kinect for Wekinator feature extractor
// Extracts 28 features:  
//    Features 1-25: Kinect field of vision is broken into a 5x5 grid, and the average depth is computed for each cell
//    Feature 26: Depth of the closest point to the Kinect
//    Features 27, 28: x, y coordinates of the closest point to the Kinect

// Adapted from
// Daniel Shiffman's Kinect Point Cloud example
// http://www.shiffman.net
// https://github.com/shiffman/libfreenect/tree/master/wrappers/java/processing

// Requires OpenKinect, oscP5, and netP5 to be installed and working. (And a Kinect, of course!)

import org.openkinect.freenect.*;
import org.openkinect.processing.*;

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress dest;

// Kinect Library object
Kinect kinect;

// Size of kinect image
int w = 640;
int h = 480;

//Local vars for feature computation:
int numH = 5;
int numV = 5;
int minDepth;
int minDepthX;
int minDepthY;
float[] avgD = new float[numH * numV]; //average depths



// Angle for rotation
float a = 0;

// We'll use a lookup table so that we don't have to repeat the math over and over
float[] depthLookUp = new float[2048];

void setup() {
  // Rendering in P3D
  size(640, 480, P3D);
  //size(640, 480);
  kinect = new Kinect(this);
  kinect.initDepth();
  

  // Lookup table for all possible depth values (0 - 2047)
  for (int i = 0; i < depthLookUp.length; i++) {
    depthLookUp[i] = rawDepthToMeters(i);
  }
  /* start oscP5, listening for incoming messages at port 12001 (Could change this port) */
  oscP5 = new OscP5(this, 12001);
  dest = new NetAddress("127.0.0.1", 6448); //Send to Wekinator at 6448 (don't change), running on local host (could change host)
  
  textAlign(CENTER, CENTER);
  rectMode(CORNER);
  colorMode(RGB, 100);
}

void draw() {

  background(0);

  // Get the raw depth as array of integers
  int[] depth = kinect.getRawDepth();

  // We're just going to calculate and draw every 4th pixel (equivalent of 160x120)
  int skip = 4;

  // Translate
  pushMatrix();
  translate(width/2, height/2, -50);
  // Scale up by 400 for rendering
  float factor = 400;
  stroke(0, 255, 0);
  for (int x=0; x<w; x+=skip) {
    for (int y=0; y<h; y+=skip) {
      int offset = x+y*w;
      // Convert kinect data to world xyz coordinate
      int rawDepth = depth[offset];
      PVector v = depthToWorld(x, y, rawDepth);
      pushMatrix();
      translate(v.x*factor, v.y*factor, factor-v.z*factor);
      // Draw a point
      point(0, 0);
      popMatrix();
    }
  }
  
  
  
  
  
  //Draw last closest point as white box
  pushMatrix();
  PVector v = depthToWorld(minDepthX, minDepthY, minDepth);
  stroke(255, 255, 255);
  fill(255, 255, 255);
  translate(v.x*factor, v.y*factor, factor-v.z*factor);
  rect(0, 0, 15, 15);
  popMatrix();

  popMatrix();


  //Compute features and send to Wekinator:
  // if(frameCount % 2 == 0) { //Could optionally send less frequently to be more efficient
  computeGridFeatures(depth); 
  computeMinDepthAndPos(depth); 
  sendOsc();
  // }
  
  
  //println(kinect.width);
}

//Send all features to Wekinator as a single vector of floats
void sendOsc() {
  OscMessage msg = new OscMessage("/wek/inputs");
  for (int i = 0; i < avgD.length; i++) { 
    msg.add(avgD[i]);
  }
  msg.add((float)minDepth);
  msg.add((float)minDepthX);
  msg.add((float)minDepthY);
  oscP5.send(msg, dest);
}


void computeGridFeatures(int[] ds) {
  int horizSize = w / numH;
  int vertSize = h / numV;
  int whichSquare = 0;
  float scaleFactor = 1.0 / (horizSize * vertSize);
  for (int hNum = 0; hNum < numH; hNum++) {
    for (int vNum = 0; vNum < numV; vNum++) {
      //Compute average depth in this square.
      float totDepth = 0f;
      for (int x = horizSize * hNum; x < horizSize * (hNum + 1); x++) {
        for (int y = vertSize * vNum; y < vertSize * (vNum + 1); y++) {
          int offset = x+y*w;
          totDepth += ds[offset];
         //println(x);
        } 
      }
      //inefficient:
      avgD[whichSquare] = totDepth * scaleFactor;
      
      //broken text viz
      //textSize(32);
      //text((int)avgD[whichSquare], hNum* width/5+ width/20 , vNum*height/5 + height/20, -150);
      whichSquare++;
    }
  }
}

void computeMinDepthAndPos(int[] ds) {
  minDepth = Integer.MAX_VALUE;
  int skip = 4;
  for (int x=0; x<w; x+=skip) {
    for (int y=0; y<h; y+=skip) {
      int offset = x+y*w;
      if (ds[offset] < minDepth) {
        minDepth = ds[offset];
        minDepthX = x;
        minDepthY = y;
      }
    }
  }
}




// These functions come from: http://graphics.stanford.edu/~mdfisher/Kinect.html
float rawDepthToMeters(int depthValue) {
  if (depthValue < 2047) {
    return (float)(1.0 / ((double)(depthValue) * -0.0030711016 + 3.3309495161));
  }
  return 0.0f;
}

PVector depthToWorld(int x, int y, int depthValue) {

  final double fx_d = 1.0 / 5.9421434211923247e+02;
  final double fy_d = 1.0 / 5.9104053696870778e+02;
  final double cx_d = 3.3930780975300314e+02;
  final double cy_d = 2.4273913761751615e+02;

  PVector result = new PVector();
  double depth =  depthLookUp[depthValue];//rawDepthToMeters(depthValue);
  result.x = (float)((x - cx_d) * depth * fx_d);
  result.y = (float)((y - cy_d) * depth * fy_d);
  result.z = (float)(depth);
  return result;
}