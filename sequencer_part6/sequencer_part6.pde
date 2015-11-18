import processing.sound.*;

/*

Creating a graphical interface for controlling our patterns

*/

Sequencer seq;
int[][] patterns = {{61,63,65,66,68},{0,0,0,74,0,0},{0,0,0,0,0,65,0,0},{0,0,0,68},{0,0,0,0,0,0,61},{44,44,44,44}};

SinOsc[] sin;

int barWidth = 50;


void setup(){
  size(400,400);
  seq = new Sequencer();
  sin = new SinOsc[patterns.length];
  
  for(int i=0; i<patterns.length;i++){
    seq.addPattern(str(i),patterns[i]);
    sin[i] = new SinOsc(this);
    //sin[i].play();
  }
  
  
  seq.setTempo(30);
  
  setupUI();
}

void draw(){
  background(255);
  
  if(seq.checkState()){
    for(int i = 0; i < seq.getNumberOfPatterns(); i++){
      int state = seq.getState(str(i));
      if(state == 0){
        sin[i].amp(0.0);
      } else {
        sin[i].amp(0.8);
        sin[i].freq(midiToFreq(state));
      }
      
    }
    
  }
  
  drawUI();
}

// This function calculates the respective frequency of a MIDI note
float midiToFreq(int note){
    return (pow(2, ((note-69)/12.0)))*440; 
}