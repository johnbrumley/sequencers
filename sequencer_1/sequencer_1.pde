import de.bezier.guido.*;
import processing.sound.*;

TriOsc oscillator;
Env envelope;

float attackTime, sustainTime, sustainLevel, releaseTime; // times are in seconds

int[][] seq = {
                {1,2,1,2,2,1,1,2},
                {0,0,0,9},
                {5,5,5,5,5}
              };

Sequencer s;

void setup(){
  size(640, 360);
  
  oscillator = new TriOsc(this);
  envelope = new Env(this);

  // init ASR
  attackTime = 0.0001;
  sustainTime = 0.06;
  sustainLevel = 1;
  releaseTime = 0.5;
  
  s = Sequencer.getInstance();
  
  // add patterns to sequencer
  s.addSequence(seq[0].length);
  s.addSequence(seq[1].length);
  
  // start sequencer
  s.startSequencer();
  
  // listen to the sequencer
  Step step = new Step();
  s.addListener(step);
}

void draw(){

}

// Class that uses the sequencer callback function
class Step implements SequencerListener{
  @Override
  // steps[] returns the current index of each pattern
  public void nextStep(int[] steps){
    for(int i = 0; i < steps.length; i++){
      println("pattern #:" + i + ": " + seq[i][steps[i]]);
    }
  }
  
}