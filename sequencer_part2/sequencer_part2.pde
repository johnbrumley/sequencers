import processing.sound.*;

/*

Multiple Patterns: The Sequencer class has been tucked into its own tab and given
the ability to store multiple patterns at the same time. Now when you use the
newPattern function, you pass two parameters, the name of your pattern and the
pattern itself. You can also append an existing pattern by calling appendPattern with
the name of the existing pattern and an integer array of values you wish to add.

When getting the updated steps in each sequence you pass the name of the pattern
that you are checking on. Because the state of the sequencer is always updating
you can "mute" a pattern by not checking on it.

*/


int[] treblePattern = {57,59,60,62,60,62};
int[] bassPattern = {45,45,45,45,47,47,47,47};

Sequencer sequencer;
boolean patternSwitch;
int patternCounter = 0;

void setup() {
  sequencer = new Sequencer();
  sequencer.setTempo(150);
  sequencer.newPattern("treble", treblePattern);
  sequencer.newPattern("bass", bassPattern);
  
  patternSwitch = true;
  
}

void draw() {
  if(sequencer.checkState()){
    
    // here is an example of alternating between two patterns
    
    // when we hit the end of one pattern, switch to the other
    if(patternSwitch && patternCounter >= treblePattern.length){
      patternSwitch = false;
      patternCounter = 0;
      sequencer.moveToStep(0); // set pattern back to first note
    } else if(!patternSwitch && patternCounter >= bassPattern.length){
      patternSwitch = true;
      patternCounter = 0;
      sequencer.moveToStep(0);
    }
    
    // output which pattern we are on and the current note
    if(patternSwitch){
      println("first pattern: " + sequencer.getState("treble"));
    } else {
      println("second pattern: " + sequencer.getState("bass"));
    }
    
    patternCounter++; // increment our variable to test where we are in each pattern
  }
}