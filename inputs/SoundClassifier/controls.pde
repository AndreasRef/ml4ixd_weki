
void sliderSetup() {

  cp5.addSlider("cutOff")
    .setPosition(graphStartX, margin*1)
    .setSize(100, 20)
    .setValue(400)
    .setRange(0, 1000)
    ;    
    
  cp5.addSlider("maxValue")
    .setPosition(graphStartX +150, margin*1)
    .setSize(100, 20)
    .setValue(400)
    .setRange(200, 600)
    ;

  cp5.addSlider("speed")
    .setPosition(graphStartX, margin*2.5)
    .setSize(100, 20)
    .setValue(5)
    .setRange(0, 10)
    ;  

  cp5.addSlider("freqCut")
    .setPosition(graphStartX +150, margin*2.5)
    .setSize(100, 20)
    .setValue(0)
    .setRange(0, 800)
    ;  

}