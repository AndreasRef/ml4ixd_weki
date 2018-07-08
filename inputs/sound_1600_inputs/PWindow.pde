
////This Pwindow is dedicated to create sketches using the wekinator classification
////seperated from the spectrogram tool. 

//class PWindow extends PApplet {
//  PWindow() {
//    super();
//    PApplet.runSketch(new String[] {this.getClass().getSimpleName()}, this);
//  }

//  //---------------------------------------------------------------------------------
//  // Set sketch variables 
//  color[] colors = {#FAF3DD, #FFF05A, #FF6663, #4EA699, #9DD1F1, #30332E};

//  //---------------------------------------------------------------------------------
//  // Set the window size here
//  void settings() {
//    size(500, 500);
//  }

//  //---------------------------------------------------------------------------------
//  // Set seutp properties
//  void setup() {
//    background(colors[0]);
//    textAlign(CENTER, CENTER);
//  }

//  //---------------------------------------------------------------------------------
//  // Start of draw
//  void draw() {

//    switch(output) {
//    case 1:
//      background(colors[0]);
//      break;

//    case 2:
//      background(colors[1]); // - "yellow"
//      break;

//    case 3: 
//      background(colors[2]); // - "red"
//      break;

//    case 4: 
//      background(colors[3]); // - "green"
//      break;

//    case 5:
//      background(colors[4]); // - "blue"
//      break;
//    }

//    text("output " + output, width/2, height/2);
//  }
//}