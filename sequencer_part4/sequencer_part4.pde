import processing.sound.*;

/*

Loading in Patterns from a JSON file using the following format:

{
  "patterns" : [
    {"name":"theLongestNameForAPatternEver","pattern":[1,2,3,4,5]},
    {"name":"theSecondLongestNameForAPatternEver","pattern":[0,0,0,0,67,0]}
  ]
}

If you have a lot of patterns and don't want to clutter your code
with:

int[] firstPattern = {0,1,2,3,4,5};
String firstPatternName = "chillPattern";

You can store and edit your patterns in an external file. Calling the 
loadPatternsFromJSON("nameOfMyPatternFile.json") will automatically add
all of your patterns to the sequencer. Note: The JSON file must be added to
your project (look under Sketch->Add File...) before you try using this method.


*/

// our sequencer
Sequencer sequencer;

SawOsc saw;
LowPass lowPass;
int newLowPassValue;
int lowPassValue;
Env env;

void setup(){
  size(400,200);
  // Setup our sequencer
  sequencer = new Sequencer();
  // load all of our Patterns from our data file to our Sequencer
  sequencer.loadPatternsFromJSON("patterns.json");
  
  sequencer.setTempo(160);
  
  saw = new SawOsc(this);
  saw.play();
  
  lowPass = new LowPass(this);
  lowPass.process(saw, 200);
  newLowPassValue = 500;
  lowPassValue = 500;

}

void draw(){
  
  // See if it is time for the next step
  if(sequencer.checkState()){
    // grab all of the states of our sequencers at once, getAllStates() returns
    // an IntDict which is like an array except each value is labeled with a String or key
    IntDict currentStates = sequencer.getAllStates();
    // optimized for loop to iterate over all of the keys in our IntDict
    for (String theKey : currentStates.keys()) {
      int value = currentStates.get(theKey);
      if (theKey.equals("sawMelody")) {
        float newFreq = midiToFreq(value); // convert MIDI values to Hz
        saw.freq(newFreq);
      } else if (theKey.equals("sawAmplitude")){
        saw.amp((float)value/100); // convert for 0.0 to 1.0 value
      } else if (theKey.equals("sawPan")){
        saw.pan((float)value/100); // convert to -1.0 to 1.0 value
      } else if (theKey.equals("sawFilterFrequency")){
        // randomly set a new value for the filter frequency 
        if(random(100) > 90) {
          newLowPassValue = value;
        }
      }
    }
  }
  
  // rather than jump to the new frequency for the filter, we'll slide there using lerp()
  lowPassValue = floor(lerp(lowPassValue,newLowPassValue,0.01));
  lowPass.freq(lowPassValue);
  
}

// This function calculates the respective frequency of a MIDI note
float midiToFreq(int note){
    return (pow(2, ((note-69)/12.0)))*440; 
}