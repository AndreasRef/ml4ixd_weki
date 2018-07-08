

//--------------------------------------------------------------------------------
//Send the spectogram array as a msg to wekinator
void sendOsc(color[] px) {
  OscMessage msg = new OscMessage("/wek/inputs");
  // msg.add(px);
  for (int i = 0; i < px.length; i++) {
    msg.add(float(px[i]));
  }
  oscP5.send(msg, dest);
}

//--------------------------------------------------------------------------------
//Receive inputs from wekinator
void oscEvent(OscMessage theOscMessage) {
  println("print something");
  if (theOscMessage.checkAddrPattern("/wek/outputs")==true) {
    output = int(theOscMessage.get(0).floatValue());
    
    //smooth incoming inputs from wekinator. if response time is to slow, increase frameRate,
    //or lower the sampleSize variable
    output = avrOutput(output);
  }
}

//--------------------------------------------------------------------------------
//Smoothing algortigm to smooth incoming wek values.
int avrOutput(int output_) {
  boolean match = true;
  classSample = splice(classSample, output_, 0);
  classSample = subset(classSample, 0, sampleSize); 
  println(classSample);

  int first = classSample[0];
  for (int i = 1; i < classSample.length; i++) {
    if (classSample[i] != first) match = false;
  }

  if (match) {
    realOutput = output_; 
    oldOutput = output_;
  } else realOutput = oldOutput;

  return realOutput;
}


//--------------------------------------------------------------------------------
//SEND OUTPUT NAMES BACK TO WEKINATOR
void sendOscNames() {
  OscMessage msg = new OscMessage("/wekinator/control/setOutPutNames");
  msg.add("gesture");
  oscP5.send(msg, dest);
}