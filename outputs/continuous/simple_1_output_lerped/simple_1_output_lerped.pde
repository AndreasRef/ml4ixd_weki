import oscP5.*;
OscP5 oscP5;
float regressionValue;
float lerpedValue;
float lerpFactor = 0.15; //Set between 0.0 (full smoothing) and 0.99 (no smoothing)

void setup() {
  size(600, 400);
  oscP5 = new OscP5(this, 12000);
}

void draw() {
  background(0);
  textSize(64);
  text(lerpedValue, width/2, height/2);
  ellipse(width/3, height/2, lerpedValue * 100, lerpedValue * 100);
  lerpedValue = lerp(lerpedValue, regressionValue, lerpFactor);
}

void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/wek/outputs") == true) {
    regressionValue = theOscMessage.get(0).floatValue();
  }
}