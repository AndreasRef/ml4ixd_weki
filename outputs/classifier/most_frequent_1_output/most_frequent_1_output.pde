//Small bug if windowSize is too low: https://forum.processing.org/two/discussion/comment/114911#Comment_114911

import oscP5.*;
OscP5 oscP5;
int currentClass; 
int mostFrequentClass = 0;

int[] storedValues;
int count = 0;
int windowSize = 60;
boolean arrayIsFull = false;

void setup() {
  size(600, 400);
  oscP5 = new OscP5(this, 12000);
  storedValues = new int[windowSize];
}

void draw() {
  background(0);
  textSize(14);
  text("uses the last " + windowSize + " calculations from Wekinator to find the mostFrequentClass", 10, 30);
  if (!arrayIsFull) text("mostFrequentClass is set to 0 until the array is filled out", 10, 55);
  textSize(48);
  text("currentClass: " + currentClass, 10, height/2 - 50);
  text("mostFrequentClass: " + mostFrequentClass, 10, height/2 + 25);
  
  if (arrayIsFull) {
    mostFrequentClass = mode(storedValues);
  }
  
  if (mostFrequentClass == 1) {
    //Do something on class 1
  } else if (mostFrequentClass == 2) {
    //Do something else on class 2
  } else {
    //Else do this
  }
}

void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/wek/outputs") == true) {
    currentClass = (int) theOscMessage.get(0).floatValue();
    AddNewValue(currentClass);
  }
}

void AddNewValue(int val)
{
  if(count < storedValues.length)
  {
    //array is not full yet
    storedValues[count++] = val; 
  }
  else
  {
    arrayIsFull = true;
    
    //shift all of the values, drop the first one (oldest) 
    for(int i = 0; i < storedValues.length-1; i++)
    {
      storedValues[i] = storedValues[i+1] ;
    }
    //the add the new one
    storedValues[storedValues.length-1] = val;
  }
}

int mode(int[] array) {
    int[] modeMap = new int [array.length];
    int maxEl = array[0];
    int maxCount = 1;

    for (int i = 0; i < array.length; i++) {
        int el = array[i];
        if (modeMap[el] == 0) {
            modeMap[el] = 1;
        }
        else {
            modeMap[el]++;
        }

        if (modeMap[el] > maxCount) {
            maxEl = el;
            maxCount = modeMap[el];
        }
    }
    return maxEl;
}