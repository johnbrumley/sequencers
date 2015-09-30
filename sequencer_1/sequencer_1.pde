import de.bezier.guido.*;
import processing.sound.*;

TriOsc oscillator;
Env envelope;

float attackTime, sustainTime, sustainLevel, releaseTime; // times are in seconds

int lastTime;
int millisPerStep;
int currentStep = 0;

int[] sequence;

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
  
  lastTime = millis();
  millisPerStep = 500;
  
  sequence = new int[8];
  for (int i = 0; i < sequence.length; i++){
    sequence[i] = floor(random(64));
  }
  
  s = Sequencer.getInstance();
  s.addSequence(10);
  s.startSequencer();
  
  // listen to the sequencer
  Step step = new Step();
  s.addListener(step);
}

void draw(){

}