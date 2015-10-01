import processing.sound.*;

Slider slider;
CheckBox[] boxes;
CircleToggle[]toggles;

int gridWidth;
int gridHeight;
int currentStep = 0;
int tempo = 500;
int lastTime = 0;

int[][] patterns;

SinOsc[] waves;
Env env;

// Envelope Parameters
float attackTime = 0.01;
float sustainTime = 0.004;
float sustainLevel = 0.1;
float releaseTime = 0.04;

void setup ()
{
    size( 450, 250 );
    
    Interactive.make(this);
    
    gridWidth = ((width-50)/25);
    gridHeight = ((height-50)/25);
    
    initUI();
    
    // 2d array to store patterns
    patterns = new int[gridHeight][gridWidth];
    for(int i = 0; i < gridHeight; i++){
      for(int j = 0; j < gridWidth; j++){
        patterns[i][j] = 0;
      }
    }
    
    // create a separate wave for each row
    waves = new SinOsc[gridHeight];
    for(int i = 0; i < gridHeight; i++){
      waves[i] = new SinOsc(this);
      waves[i].freq(i*80 + 100);
      waves[i].amp(0.1);
    }
    
    // Create the envelope 
    env  = new Env(this); 
    
    lastTime = millis();
}

void draw ()
{
    background( 20 );
    
    checkPatternBoxes();
    
    if(millis() - lastTime > tempo){
      
      currentStep++;
      if(currentStep >= gridWidth){
        currentStep = 0;
      }
      
      for(int i = 0; i < patterns.length; i++){
        if(patterns[i][currentStep] == 1 && toggles[i].isChecked()){
          waves[i].play();
          env.play(waves[i], attackTime, sustainTime, sustainLevel, releaseTime);
        }
      }
      
      // update variables
      tempo = floor(slider.value*1000) + 50;
      lastTime = millis();
    }
}

void initUI(){
  // store checkboxes
    boxes = new CheckBox[ gridWidth * gridHeight];
    int currentBox = 0;
    for ( int i = 0; i < height-50; i+= 25 ) {
      for( int j = 0; j < width-50; j+= 25 ) {
        boxes[currentBox] = new CheckBox(25+j, 25+i, 24, 24 );
        currentBox++;
      } 
    }
    
    toggles = new CircleToggle [gridHeight];
    for(int i = 0; i < toggles.length; i++){
      toggles[i] = new CircleToggle(5, 30+i*25, 15, 15);
    }
    
    // Slider
    slider = new Slider(2, 2, width-4, 16 );
}


// updates patterns and GUI based on the state of the boxes/toggles
void checkPatternBoxes(){
  // check which boxes are checked
  for (int i = 0; i < boxes.length; i++) {
    if(i%gridWidth == currentStep){
      boxes[i].setActive(true);
    } else {
      boxes[i].setActive(false);
    }
    
    if(boxes[i].isChecked()){
      patterns[floor(i/gridWidth)][i%gridWidth] = 1;
    } else {
      patterns[floor(i/gridWidth)][i%gridWidth] = 0;
    }
    
    // if muted set mute value
    if(toggles[floor(i/gridWidth)].isChecked()){
      boxes[i].setMute(false);
    } else {
      boxes[i].setMute(true);
    }
  }
}