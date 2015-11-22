/* 

Sequencer Class

Keeps track of the pattern state and timing

NOTE:

Modifies Sequencer class to use an internal Pattern class that allows
multiple named patterns to be stored and iterated over.

*/

class Sequencer {
  ArrayList<Pattern> patterns = new ArrayList<Pattern>();

  float tempo; // tempo in milliseconds
  int lastTime; // keep track of time
  
  int minStepNoteValue = 16; // what do we want our min step size to be, here 16th notes
  
  boolean firstNote;
  
  // initial setup
  Sequencer(){
    tempo = bpmToMillis(120)/(minStepNoteValue/4); // default tempo is 120 bpm
    lastTime = millis();
    firstNote = true;
  }
  
  void addPattern(String _name, int[] _p){
    patterns.add(new Pattern(_name, _p));
  }
  
  void loadPatternsFromJSON(String fileName){
    JSONObject json = loadJSONObject(fileName);
    JSONArray values = json.getJSONArray("patterns");
    
    int[] p;
    for (int i = 0; i < values.size(); i++) {
      
      JSONObject pattern = values.getJSONObject(i);
      
      String name = pattern.getString("name");
      JSONArray patternValues = pattern.getJSONArray("pattern");
      
      p = new int[patternValues.size()];
      
      for(int j = 0; j < p.length; j++){
        p[j] = patternValues.getInt(j);
      }
      this.addPattern(name, p); 
    }
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
    if(millis() - lastTime > tempo && !firstNote){
      nextStep = true;
      // increment the our current steps
      for (Pattern p : patterns) {
        p.next();
      }
      
      lastTime = millis(); // record the time
    } else if(millis() - lastTime > tempo && firstNote){
      nextStep = true;
      firstNote = false;
      lastTime = millis();
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
  
  IntDict getAllStates(){
    IntDict states = new IntDict();
    for (Pattern p : patterns) {
        states.set(p.name,p.getCurrentStep());
      }
    return states;
  }
  
  int[] getEntirePattern(String name){
    int[] patternNotFound = {-1};
    for(Pattern p : patterns){
      if(p.name.equals(name)){
        return p.getPattern();
      }
    }
    return patternNotFound;
  }
  
  void mixPattern(String name, int amount){
    for(Pattern p : patterns){
      if(p.name.equals(name)){
        p.swapValuesRelativeToStartingPattern(amount);
      }
    }
  }
  
  // utility for converting to milliseconds, since we're using that
  // for the internal timing
  float bpmToMillis(float b){
    return (1/(b/60)) * 1000;
  }
  
  // Pattern Class, handles individual sequences and related logic
  class Pattern {
    String name;
    int[] masterP;
    int[] p;
    int currentStep;
    boolean loop;
    
     Pattern(String _name, int[] _values){
       name = _name;
       currentStep = 0;
       loop = true;
       p = _values;
       masterP = _values;
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
     
     int getLength(){
       return p.length;
     }
     
     int[] getPattern(){
       return p;
     }
     
     void resetPattern(){
       p = masterP;
     }
     
     int distanceFromMaster(int[] newArray){
       int distance = 0;
       for(int i = 0; i < masterP.length; i++){
         int stepDistance = abs(masterP[i] - newArray[i]);
         distance += stepDistance;
       }
       return distance;
     }
     
     void swapByIndices(int[] a, int i, int j){
       int tempVal = a[i];
       p[i] = p[j];
       p[j] = tempVal;
     }
     
     // algorithmically modifying the pattern
     void swapValuesRelativeToStartingPattern(int numberToSwap){
       resetPattern();
       while (distanceFromMaster(p) < numberToSwap) {
         int firstIndex = floor(random(p.length));
         int secondIndex = floor(random(p.length));
         while(firstIndex == secondIndex) secondIndex = floor(random(p.length));
         swapByIndices(p,firstIndex,secondIndex);
       }
     }
  }
}