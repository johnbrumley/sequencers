import java.util.Map; // using a HashMap for this, A custom Pattern Class in later ones

/* 

Sequencer Class

Keeps track of the pattern state and timing

*/

class Sequencer {
  HashMap<String,ArrayList> patterns; // keep track of our patterns
  IntDict currentSteps;

  float tempo; // tempo in milliseconds
  int lastTime; // keep track of time
  
  // initial setup
  Sequencer(){
    patterns = new HashMap<String, ArrayList>();
    currentSteps = new IntDict();

    tempo = bpmToMillis(120); // default tempo is 120 bpm
  }
  
  // new pattern or replace old pattern
  void newPattern(String name, Note[] p){
    ArrayList<Note> pattern = new ArrayList<Note>();
    for(int i = 0; i < p.length; i++){
      pattern.add(p[i]);
    }
    currentSteps.set(name, 0);
    patterns.put(name, pattern);
  }
  
  // increase length of existing pattern
  void appendPattern(String name, Note[] patternExtension){
    ArrayList<Note> pattern = patterns.get(name);
    for(int i = 0; i < patternExtension.length; i++){
      pattern.add(patternExtension[i]);
    }
    patterns.put(name, pattern);
  }
  
  void setTempo(int _tempo){
    tempo = bpmToMillis(_tempo);
  }
  
  void moveToStep(int step){
    for (Map.Entry<String,ArrayList> e : patterns.entrySet()) {
        String currentKey = e.getKey();
        // if too large for the sequence, set to the beginning
        if(step >= e.getValue().size()){
          step = 0;
        }
        // store current step back in dict
        currentSteps.set(currentKey, step);
      }
  }
  
  // Tell us if we are on the next step of the sequence based on our tempo
  boolean checkState(){
    boolean nextStep = false;
    if(millis() - lastTime > tempo){
      nextStep = true;
      // increment the our current steps
      for (Map.Entry<String,ArrayList> e : patterns.entrySet()) {
        String currentKey = e.getKey();
        int currentStep = currentSteps.get(currentKey);
        currentStep++;
        // loop back to the start if we hit the end
        if(currentStep >= e.getValue().size()){
          currentStep = 0;
        }
        // store current step back in dict
        currentSteps.set(currentKey, currentStep);
      }
      
      lastTime = millis(); // record the time
    }
    return nextStep;
  }
  
  // return the value of the current step
  Note getState(String name){
    Note value = new Note(0,0,'z');
    ArrayList<Note> pattern = patterns.get(name);
    if(pattern.size() > 0){
      value = pattern.get(currentSteps.get(name));
    }
    return value;
  }
  
  // utility for converting to milliseconds, since we're using that
  // for the internal timing
  float bpmToMillis(float b){
    return (1/(b/60)) * 1000;
  }
}