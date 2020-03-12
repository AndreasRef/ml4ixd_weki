/* By Lasse Korsgaard https://twitter.com/lassekorsgaard
 
 Wekinator Setup:
 100 inputs
 1 output
 All Classifiers 
 * classes
 
 This sketch requires the following libraries to be installed:
 video
 oscP5
 netP5
 */

import processing.video.*;
import oscP5.*;
import netP5.*;

Capture video;
int videoWidth = 640;
int videoHeight = 480;
int totalPixels;
int blockWidth;
int blockHeight;
int blocksTotal;
int blocksX = 10;
int blocksY = 10;
int blockPixels;

int currentState = 0;

int padding = 20;
color[] blocks = new color[blocksX * blocksY];

boolean isShowingInput = true;

// OSC
OscP5 oscP5Sender;
OscP5 oscP5Receiver;
NetAddress destination;


PFont font;
PFont bigFont; 

void setup() {
  size(680, 560);

  noStroke();
  font = createFont("RobotoMono-Regular.ttf", 18);
  textFont(font);
  bigFont = createFont("RobotoMono-Regular.ttf", 60);



  totalPixels = videoWidth * videoHeight;
  blocksTotal = blocksX * blocksY;
  blockWidth = videoWidth / blocksX;
  blockHeight = videoHeight / blocksY;
  blockPixels = blockWidth * blockHeight; 

  String[] cameras = Capture.list();
  if (cameras == null) {
    println("Camera fail");
    video = new Capture(this, videoWidth, videoHeight);
  } else if (cameras.length == 0) {
    println("No cameras available");
  } else {
    //video = new Capture(this, videoWidth, videoHeight);
    video = new Capture(this, cameras[0]);
    video.start();
    loadPixels();
  }

  oscP5Sender = new OscP5(this, 9000);
  oscP5Receiver = new OscP5(this, 12000);
  destination = new NetAddress("127.0.0.1", 6448);
}

void draw() {




  if (video.available() == true) {

    background(0);

    if (isShowingInput == false) {
      if (currentState == 0) {
        fill(0);
      }

      if (currentState == 1) {
        fill(255, 0, 0);
      }

      if (currentState == 2) {
        fill(0, 0, 255);
      }

      rect(padding, height - videoHeight - padding, 600, 400);
      fill(255);
      textFont(bigFont);
      textAlign(CENTER, CENTER);
      text(currentState, width / 2, height / 2);
    }

    video.read();
    video.loadPixels();

    int blockIndex  = 0;
    for (int x = 0; x < videoWidth; x += blockWidth) {
      for (int y = 0; y < videoHeight; y += blockHeight) {
        float r = 0;
        float g = 0;
        float b = 0;

        for (int bx = 0; bx < blockWidth; bx++) {
          for (int by = 0; by < blockHeight; by++) {
            int index = (x + bx) + (y + by) * videoWidth;
            r += red(video.pixels[index]);
            g += green(video.pixels[index]);
            b += blue(video.pixels[index]);
          }
        }

        blocks[blockIndex] = color(r / blockPixels, g / blockPixels, b / blockPixels);
        fill(blocks[blockIndex]);

        blockIndex++;

        float videoScale = 0.2;
        float videoOffsetX = width - (videoWidth * videoScale) - padding;
        float videoOffsetY = height - (videoHeight * videoScale) - padding;

        if (isShowingInput) {
          videoScale = 1;
          videoOffsetX = padding;
          videoOffsetY = height - videoHeight - padding;
        }
        rect((x * videoScale) + videoOffsetX, (y * videoScale) + videoOffsetY, blockWidth * videoScale, blockHeight * videoScale);
      }
    }
    if (frameCount % 2 == 0) {
      sendOsc(blocks);
    }

    fill(255);
    textAlign(LEFT, CENTER);
    textFont(font);
    if (isShowingInput) {
      text("Input", 20, 30);
    } else {
      text("Output", 20, 30);
    }
  }
}


void sendOsc(int[] colors) {
  OscMessage message = new OscMessage("/wek/inputs");
  for (int i = 0; i < colors.length; i++) {
    message.add(float(colors[i]));
  }
  oscP5Sender.send(message, destination);
}

void oscEvent(OscMessage message) {

  if (message.checkAddrPattern("/wek/outputs") == true) {
    currentState = (int) message.get(0).floatValue();
  }
}

void keyPressed() {
  if (key == ' ') {
    isShowingInput = !isShowingInput;
  }
}
