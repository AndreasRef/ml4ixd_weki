void soundAnalyse() {

  //--------------------------------------------------------------------------------
  //Perform a forward FFT on the samples in the input buffer.
  fft.forward(in.mix);

  //--------------------------------------------------------------------------------
  //freqCut makes it possible to select a hz range to analyze in the sketch
  binSize = fft.specSize() - freqCut; // raw signal / full spectrum

  //--------------------------------------------------------------------------------
  //Go through all the bands in the fft analyse. 
  for (int i = 0; i < binSize; i++)
  {

    //--------------------------------------------------------------------------------
    //VLoc is controlling where on the Y-axe the reading sould be placed. 
    vLoc = i*resolution/(binSize);

    //--------------------------------------------------------------------------------
    //Find the amplitude of the index band
    value = (int)Math.round(Math.max(0, 4*20* Math.log10(1000*fft.getBand(int(i)))));

    //--------------------------------------------------------------------------------
    //Uncomment to enable auto tuning/calibrating of the amplitude 
    //store self tuning value
    /*   if (maxValue < value) {
     maxValue = value;
     //  println("max amplitude: " + maxValue);
     }
     */

    //--------------------------------------------------------------------------------
    //create a newvalue for the amplite, which lets the cutOff value decide
    //how much of the background noise we want
    newValue = (int)Math.max(0, (value - map(value, 0, maxValue, cutOff, 0)));

    //--------------------------------------------------------------------------------
    //lots of confusing math that acts as a gradient and then set the color
    r = constrain(50+norm(newValue, 0, maxValue)*(370), 0, 255);
    g = constrain(50+norm(newValue, 0, maxValue)*norm(newValue, 0, maxValue)*220, 0, 255);
    b = constrain((70+norm(newValue, 0, maxValue)*(maxValue/2-newValue)), 0, 255);

    //--------------------------------------------------------------------------------
    //set the last row of pixels in the pixel array to the new reading.
    color col = color(r, g, b); 
    Pixels[resolution + (((resolution-1)-vLoc)*resolution-1)] = col;
  }
}