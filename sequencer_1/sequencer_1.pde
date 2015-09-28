import de.bezier.guido.*;
import processing.sound.*;

TriOsc oscillator;
Env envelope;

float attackTime, sustainTime, sustainLevel, releaseTime; // times are in seconds

int lastSecond;

void setup(){
  size(640, 360);
  
  oscillator = new TriOsc(this);
  envelope = new Env(this);
  
  // init ASR
  attackTime = 0.0001;
  sustainTime = 0.06;
  sustainLevel = 1;
  releaseTime = 0;
  
  lastSecond = second();
  
}

void draw(){
  if(second() != lastSecond){
    oscillator.play(440,0.8);
    envelope.play(oscillator, attackTime, sustainTime, sustainLevel, releaseTime);
    lastSecond = second();
  }
}