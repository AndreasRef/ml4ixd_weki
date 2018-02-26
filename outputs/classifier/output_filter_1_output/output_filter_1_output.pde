/*
First version of a tool for filtering Wekinator classification outputs 
 based on stastical mode https://en.wikipedia.org/wiki/Mode_(statistics)
 
 - Outputs the mode + the relative occurrence of the mode (measured as percentage from 0-100) during windowSize
 - Outputs {-1} if there is no mode (in case 2 or more classes appear the same number of times during the window)
 
 www.andreasrefsgaard.dk - 2018
 */

import oscP5.*;
OscP5 oscP5;

int windowSize = 25; //How many of the last outputs from Wekinator should we look at?
int[] outputs = new int[windowSize];
int count = 0;

boolean arrayIsFull = false;

int currentClass;
int currentMode;
int currentPtc;
int filteredOutput = -1;
int threshold = 100;

void setup() {
  size(600, 400);
  oscP5 = new OscP5(this, 12000);  
  for (int i = 0; i<windowSize; i++) { //Fill everything with -1 to begin with
    outputs[i] = -1;
  }
  textSize(32);
}

void draw() {
  background(0);

  AddNewValue(currentClass);

  if (mode(outputs).get(0) != -1) {
    currentMode = mode(outputs).get(0);
    currentPtc = mode(outputs).get(1);

    if (currentPtc >= threshold) {
      filteredOutput = currentMode;
    } else {
      filteredOutput = -1;
    }
  } else {
    filteredOutput = -1;
  }

  fill(255);
  text("raw class from Wekinator: " + currentClass, 10, 1*height/5);
  text("most frequent class: " +  currentMode, 10, 2*height/5);
  text("most frequent class %: " +  currentPtc + "%", 10, 3*height/5);

  if (filteredOutput == -1) {
    fill(255, 0, 0);
  } else {
    fill(0, 255, 0);
  }
  text("filtered output: " +  filteredOutput, 10, 4*height/5);
}

void oscEvent(OscMessage message) {
  if (message.checkAddrPattern("/wek/outputs") == true) {
    currentClass = (int) message.get(0).floatValue();
  }
}


void AddNewValue(int val)
{
  if (count < outputs.length)
  {
    //array is not full yet
    outputs[count++] = val;
  } else
  {
    arrayIsFull = true;

    //shift all of the values, drop the first one (oldest) 
    for (int i = 0; i < outputs.length-1; i++)
    {
      outputs[i] = outputs[i+1] ;
    }
    //then add the new one
    outputs[outputs.length-1] = val;
  }
}


ArrayList<Integer> mode(int[] array) {
  int mode = 0;
  float pct = 0;
  HashMap<Integer, Integer> map = new HashMap();


  for (int i=0; i<array.length; i++) {

    if (map.get(array[i]) == null) {  // Check if specific key didn't exists
      map.put(array[i], 1);
    } else {                                   // Key does exists
      int count = map.get(array[i]);
      count++;
      map.remove(array[i]);
      map.put(array[i], count);
    }
  }

  // Update the highest count
  for (int i=0; i<array.length; i++) {
    int count = map.get(array[i]);
    if (count > mode) {
      mode = count;
    }
  }

  // Get all values with the highest mode
  ArrayList<Integer> m = new ArrayList();
  for (int i=0; i<array.length; i++) {
    if (map.get(array[i]) == mode && !m.contains(array[i])) {
      m.add(array[i]);
      pct = map.get(array[i]);
    }
  }

  if (m.size() == 1) { //Return modus if there is only one + the percentage within the last windowSize observations
    int convertedPtc = round(pct/(windowSize*0.01));
    m.add(convertedPtc);
    return m;
  } else { //If there are more - return empty list

    ArrayList<Integer> n = new ArrayList();
    n.add(-1);
    return n;
  }
}