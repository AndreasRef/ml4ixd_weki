import processing.video.*;
import oscP5.*;
OscP5 oscP5;
int currentClass; 
Movie[] movies;
int index = 0;

void setup() {
  size(1280, 720);
  oscP5 = new OscP5(this, 12000);
  
  movies = new Movie[2];
  for (int i = 0; i<movies.length; i++) {
   movies[i] = new Movie(this, i + ".mp4");
   movies[i].loop(); 
  }
}

void draw() {
  background(255);
  image(movies[index], 0, 0, width, height);
  
  for (int i = 0; i<movies.length; i++) {
  movies[i].volume(0.0);
  
  }
  movies[index].volume(1.0);
}

void movieEvent(Movie m) {
  m.read();
}

void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/wek/outputs") == true) {
    currentClass = (int) theOscMessage.get(0).floatValue();
    index = currentClass - 1;
  }
}