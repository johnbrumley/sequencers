import java.util.Map; // using a HashMap for this, A custom Pattern Class in later ones

/* 

Sequencer Class

Keeps track of the pattern state and timing

TODO:

Implement some way of creating random variations

Add different beat settings? maybe default to 16ths instead of quarters since
that Is what I would expect from a sequencer

Add some kind of helper for CC type values? maybe not


*/

class Sequencer {
  ArrayList<Pattern> patterns = new ArrayList<Pattern>();

  float tempo; // tempo in milliseconds
  int lastTime; // keep track of time
  
  int minStepNoteValue = 16; // what do we want our min step size to be, here 16th notes
  
  // initial setup
  Sequencer(){
    tempo = bpmToMillis(120)/(minStepNoteValue/4); // default tempo is 120 bpm
  }
  
  void addPattern(String _name, int[] _p){
    patterns.add(new Pattern(_name, _p));
  }
  
  void setTempo(int _tempo){
    tempo = bpmToMillis(_tempo)/(minStepNoteValue/4);
  }
  
  void moveToStep(int step){
   for(Pattern p : patterns){
     p.setStepValue(step);
   }
  }
  
  // Tell us if we are on the next step of the sequence based on our tempo
  boolean checkState(){
    boolean nextStep = false;
    if(millis() - lastTime > tempo){
      nextStep = true;
      // increment the our current steps
      for (Pattern p : patterns) {
        p.next();
      }
      
      lastTime = millis(); // record the time
    }
    return nextStep;
  }
  
  // return the value of the current step
  int getState(String name){
    int value = -1;
    // loop through patterns, select by name match
    for(Pattern p : patterns){
      if(p.name.equals(name)){
        value = p.getCurrentStep();
      }
    }
    return value;
  }
  
  // utility for converting to milliseconds, since we're using that
  // for the internal timing
  float bpmToMillis(float b){
    return (1/(b/60)) * 1000;
  }
  
  // Pattern Class, handles individual sequences and related logic
  class Pattern {
    String name;
    int[] p;
    int currentStep;
    boolean loop;
    
     Pattern(String _name, int[] _values){
       name = _name;
       currentStep = 0;
       loop = true;
       p = _values;
     }
     
     void reset(){
       currentStep = 0;
     }
     
     void setStepValue(int step){
       if(step >= p.length){
          step = 0;
        }
        currentStep = step;
     }
     
     void next(){
       currentStep++;
       if(loop){
         if(currentStep >= p.length){
           reset();
         }
       }
     }
     
     int getCurrentStep(){
       // make sure current step is within range, in case not looping
       if(currentStep <= p.length){
         return p[currentStep];
       } else {
         return -1;
       }
     }
  }
}