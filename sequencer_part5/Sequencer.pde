import de.bezier.math.combinatorics.*; // combinatorics library for producing variations of patterns
import java.util.Map; // using a HashMap for this, A custom Pattern Class in later ones

/* 

Sequencer Class

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
  
  void setPattern(String _name, int[] _p){
    for(Pattern pat : patterns){
      if(pat.name.equals(_name)){
        pat.replacePattern(_p);
      }
    }
    
  }
  
  void setPatternStep(String _name, int index, int value){
    for(Pattern pat : patterns){
      if(pat.name.equals(_name)){
        pat.setValueAtIndex(index, value);
      }
    }
  }
  
  void revertPattern(String _name){
    for(Pattern pat : patterns){
      if(pat.name.equals(_name)){
        pat.resetPatternToOriginal();
      }
    }
  }
  
  void loadPatternsFromJSON(String fileName){
    JSONObject json = loadJSONObject(fileName);
    JSONArray values = json.getJSONArray("patterns");
    
    int[] pat;
    for (int i = 0; i < values.size(); i++) {
      
      JSONObject pattern = values.getJSONObject(i);
      
      String name = pattern.getString("name");
      JSONArray patternValues = pattern.getJSONArray("pattern");
      
      pat = new int[patternValues.size()];
      
      for(int j = 0; j < pat.length; j++){
        pat[j] = patternValues.getInt(j);
      }
      this.addPattern(name, pat); 
    }
  }
  
  void setTempo(int _tempo){
    tempo = bpmToMillis(_tempo)/(minStepNoteValue/4);
  }
  
  void moveToStep(int step){
   for(Pattern pat : patterns){
     pat.setStepValue(step);
   }
  }
  
  // Tell us if we are on the next step of the sequence based on our tempo
  boolean checkState(){
    boolean nextStep = false;
    if(millis() - lastTime > tempo){
      nextStep = true;
      // increment the our current steps
      for (Pattern pat : patterns) {
        pat.next();
      }
      
      lastTime = millis(); // record the time
    }
    return nextStep;
  }
  
  // return the value of the current step
  int getState(String name){
    int value = -1;
    // loop through patterns, select by name match
    for(Pattern pat : patterns){
      if(pat.name.equals(name)){
        value = pat.getCurrentStep();
      }
    }
    return value;
  }
  
  IntDict getAllStates(){
    IntDict states = new IntDict();
    for (Pattern pat : patterns) {
        states.set(pat.name,pat.getCurrentStep());
      }
    return states;
  }
  
  int[] getEntirePattern(String name){
    int[] patternNotFound = {-1};
    for(Pattern pat : patterns){
      if(pat.name.equals(name)){
        return pat.getPattern();
      }
    }
    return patternNotFound;
  }
  
  void mixPattern(String name, int amount){
    for(Pattern pat : patterns){
      if(pat.name.equals(name)){
        pat.swapValuesRelativeToStartingPattern(amount);
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
    IntList originalP;
    IntList masterP;
    IntList p;
    int currentStep;
    boolean loop;
    
     Pattern(String _name, int[] _values){
       name = _name;
       currentStep = 0;
       loop = true;
       
       this.p = new IntList();
       this.masterP = new IntList();
       this.originalP = new IntList();
       for(int i = 0; i < _values.length; i++){
         this.p.append(_values[i]);
         this.masterP.append(_values[i]);
         this.originalP.append(_values[i]);
       }
     }
     
     void reset(){
       currentStep = 0;
     }
     
     void setStepValue(int step){
       if(step >= p.size()){
          step = 0;
        }
        currentStep = step;
     }
     
     void setValueAtIndex(int index,int value){
       if(index < masterP.size()){
         masterP.set(index, value);
       } else {
         println("Index out of Range");
       }
       
     }
     
     void next(){
       currentStep++;
       if(loop){
         if(currentStep >= p.size()){
           reset();
         }
       }
     }
     
     int getCurrentStep(){
       // make sure current step is within range, in case not looping
       if(currentStep <= p.size()){
         return p.get(currentStep);
       } else {
         return -1;
       }
     }
     
     int getLength(){
       return p.size();
     }
     
     int[] getPattern(){
       return p.array();
     }
     
     void resetPattern(){
       for(int i = 0; i < masterP.size(); i++){
         p.set(i, masterP.get(i));
       }
     }
     
     void resetPatternToOriginal(){
       for(int i = 0; i < originalP.size(); i++){
         masterP.set(i, originalP.get(i));
       }
     }
     
     void replacePattern(int[] newPat){
       originalP.clear();
       masterP.clear();
       p.clear();
       
       for(int i = 0; i < newPat.length; i++){
         this.p.append(newPat[i]);
         this.masterP.append(newPat[i]);
         this.originalP.append(newPat[i]);
       }
       
     }
     
     int distanceFromMaster(int[] newArray){
       int distance = 0;
       for(int i = 0; i < masterP.size(); i++){
         if(abs(masterP.get(i) - newArray[i]) > 0){
           distance++;
         }
       }
       return distance;
     }
     
     void swapByIndices(int i, int j){
       int tempVal = p.get(i);
       p.set(i, p.get(j));
       p.set(j, tempVal);
     }
     
     // algorithmically modifying the pattern
     void swapValuesRelativeToStartingPattern(int numberToSwap){
       this.resetPattern();
       for (int i = 0; i < numberToSwap; i++) {
         int firstIndex = floor(random(p.size()));
         int secondIndex = floor(random(p.size()));
         
         while(firstIndex == secondIndex) {
           secondIndex = floor(random(p.size()));
         }
  
         swapByIndices(firstIndex, secondIndex);
       }
       
     }
  }
}