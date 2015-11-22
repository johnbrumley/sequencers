import processing.sound.*;

/*

Altering the order of your patterns

Using the mixPattern() method of the Sequencer class, you can modify an existing pattern
by a specified amount. The mixPattern function takes two parameters, the first being which
pattern you intend to modify and the second the amount you want to modify the pattern. The 
amount parameter determines the number of times that two values in a pattern will be 
swapped. A higher value will result in a pattern further from your initial pattern. Using the 
revertPattern() method, you can restore a pattern to its unmixed state.

*/

// our sequencer
Sequencer seq;

// our pattern
int[] pattern = {0,0,0,0,62,0,0,0,0,0,0,0,0,0,0,0,62,0,0,0,0,0,63,0,0,0,0,0,0,62,0,0,0,0};

// our sound
SinOsc sin;
Env env;

// Times and levels for the ASR envelope
float attackTime = 0.001;
float sustainTime = 0.004;
float sustainLevel = 0.3;
float releaseTime = 0.1;

void setup(){
  size(200,200);
  
  // initialize our sequencer
  seq = new Sequencer();
  // add our pattern and name it "a"
  seq.addPattern("a",pattern);
  // set our tempo
  seq.setTempo(120);
  
  // initialize our sound objects
  sin = new SinOsc(this);
  env = new Env(this);
}

void draw(){
  background(random(100)); // visual
  
  // check if it is time for a new step
  if(seq.checkState()){
    
    // randomly shuffle our pattern
    if(random(100) > 95){
      // this will shuffle pattern "a" using 5 "moves"
      seq.mixPattern("a",5);
    }
    
    // randomly change a note
    if(random(100) > 95){
      seq.revertPattern("a"); // revert to unshuffled pattern
      int pLength = seq.getEntirePattern("a").length; // get length of our pattern
      seq.setPatternStep("a",floor(random(pLength)), 77); // pick a random step of our pattern and set to 77
    }
    
    // Print the entire pattern to console
    int[] pat = seq.getEntirePattern("a");
    for(int i = 0; i < pat.length; i++){
      print(nf(pat[i],2) + "  ");
    }
    println("");
    
    // play pattern with our synth, getState returns the value of the current step
    int state = seq.getState("a");
    if(state == 0){ // I'm using 0 as a "rest" 
      sin.play(state, 0.0);
    } else {
      sin.play(midiToFreq(state),0.8);
    }
    // modify the synth with our envelope
    env.play(sin, attackTime, sustainTime, sustainLevel, releaseTime);
    
  }
}

// This function calculates the respective frequency of a MIDI note
float midiToFreq(int note){
    return (pow(2, ((note-69)/12.0)))*440; 
}