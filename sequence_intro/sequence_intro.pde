import processing.sound.*;

/*

A sequencer can be thought of as a device executes a series
instructions over time. You can consider a sequencer as 
a specialized score for electronic and computing devices.

At an abstract level, very simple Processing sketches
are operating in a very similar way, you provide a series
of actions that Processing executes over time.

In a sequence of instructions each element is known as a 
step. A step can be whatever you would like it to be: a number,
a word, a color, a function, etc... In music, steps of a 
sequence will often be things like pitch, amplitude, if a note should
be playing, or a value related to some other
parameter. For those familiar with MIDI
these values would correspond to pitch, velocity, note-on and CC, where
a single MIDI message contains all of these values and more.

A single collection of steps is called a pattern and you can even
make sequences where each step is an entire pattern...woah

For now, lets create a sequencer with a single pattern that
sets the pitch of an oscillator.

*/

// lets create a pattern of values that we can store in an array
int[] pattern = {1,5,4,3,2,6,4,5};

// the draw loop at 30 frames per second is too fast to hear each 
// step as a discrete note, so we will slow things down to beats per minute.
int tempo = 120;

// Create a Sequencer Object to hold the pattern and tempo
Sequencer seq;

// Now we'll make an instrument to translate those values into sound
SawOsc oscillator;

void setup(){
  size(200,200);
  
  // initialize our sequencer
  seq = new Sequencer();
  // add the pattern and tempo to our sequencer
  seq.newPattern(pattern);
  seq.setTempo(tempo);
  
  // set up our oscillator
  oscillator = new SawOsc(this);
  // play the oscillator
  oscillator.play();
  
  background(0);
}

void draw(){
  
  // check if it's time for the next note
  if(seq.checkState()){
    // set the frequency of the oscillator from our pattern
    int patternValue = seq.getState();
    // map the value to an audible frequency
    int frequency = patternValue * 200;
    oscillator.freq(frequency);
  }
}


/* 

Sequencer Class

Keeps track of the pattern state and timing

*/

class Sequencer {
  IntList pattern; // A list to store the pattern
  float tempo; // tempo in milliseconds
  int lastTime; // keep track of time
  int currentStep; // keep track of which step we are on
  
  // initial setup
  Sequencer(){
    pattern = new IntList();
    tempo = bpmToMillis(120); // default tempo is 120 bpm
  }
  
  // new pattern or replace old pattern
  void newPattern(int[] _pattern){
    pattern.clear();
    pattern.append(_pattern);
  }
  
  // increase length of existing pattern
  void appendPattern(int[] _pattern){
    pattern.append(_pattern);
  }
  
  void setTempo(int _tempo){
    tempo = bpmToMillis(_tempo);
  }
  
  // Tell us if we are on the next step of the sequence based on our tempo
  boolean checkState(){
    boolean nextStep = false;
    if(millis() - lastTime > tempo){
      nextStep = true;
      // increment the current step
      currentStep++;
      // loop back to the start if we hit the end
      if(currentStep >= pattern.size()){
        currentStep = 0;
      }
      lastTime = millis(); // record the time
    }
    return nextStep;
  }
  
  // return the value of the current step
  int getState(){
    int value = 0;
    if(pattern.size() > 0){
      value = pattern.get(currentStep);
    }
    return value;
  }
  
  // utility for converting to milliseconds, since we're using that
  // for the internal timing
  float bpmToMillis(float b){
    return (1/(b/60)) * 1000;
  }
}