import processing.sound.*;

/*

Altering the order of your patterns

*/

Sequencer seq;
int[] pattern = {0,0,0,0,62,0,0,0,0,0,0,0,0,0,0,0,62,0,0,0,0,0,63,0,0,0,0,0,0,62,0,0,0,0};

SinOsc sin;
Env env;

// Times and levels for the ASR envelope
float attackTime = 0.001;
float sustainTime = 0.004;
float sustainLevel = 0.3;
float releaseTime = 0.1;

void setup(){
  size(200,200);
  seq = new Sequencer();
  seq.addPattern("a",pattern);
  
  seq.setTempo(120);
  
  sin = new SinOsc(this);
  env = new Env(this);
}

void draw(){
  background(random(100));
  
  if(seq.checkState()){
    
    if(random(100) > 95){
      seq.mixPattern("a",5);
    }
    
    if(random(100) > 95){
      seq.revertPattern("a");
      int pLength = seq.getEntirePattern("a").length;
      seq.setPatternStep("a",floor(random(pLength)), 77);
    }
    
    // Print the entire pattern
    int[] pat = seq.getEntirePattern("a");
    for(int i = 0; i < pat.length; i++){
      print(nf(pat[i],2) + "  ");
    }
    println("");
    
    int state = seq.getState("a");
    if(state == 0){
      sin.play(state, 0.0);
    } else {
      sin.play(midiToFreq(state),0.8);
    }
    
    env.play(sin, attackTime, sustainTime, sustainLevel, releaseTime);
    
  }
}

// This function calculates the respective frequency of a MIDI note
float midiToFreq(int note){
    return (pow(2, ((note-69)/12.0)))*440; 
}