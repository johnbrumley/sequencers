import java.util.*;

interface SequencerListener {
  void nextStep(int step);
}

static class Sequencer {
  
  final Timer t = new Timer();
  boolean timerDone = true;
  
  private ArrayList<SequencerListener> listeners = new ArrayList<SequencerListener>();
  private ArrayList<Sequence> sequences = new ArrayList<Sequence>();
  
  int tempo;
  int lastTime;
  boolean sequencerShouldRun;
  
  
  private Sequencer() {
    super();
    
    tempo = 500;
    //lastTime = millis();
    sequencerShouldRun = false;
  }
  
  private static class SingletonHolder { 
     private static final Sequencer INSTANCE = new Sequencer();
  }
  
  public static Sequencer getInstance() {
    return SingletonHolder.INSTANCE;
  }
  
  public void addListener(SequencerListener toAdd){
    listeners.add(toAdd);
  }
  
  public void stepTrigger() {
    for (SequencerListener sl : listeners) {
      int[] currentSteps = new int[sequences.size()];
      for (int i = 0; i < currentSteps.length; i++) {
        sl.nextStep(sequences.get(i).getCurrentStep());
        sequences.get(i).next();
      }
    }
  }
  
  public void addSequence(int lengthOfSeq){
    sequences.add(new Sequence(lengthOfSeq));
  }
  
  public void startSequencer(){
    
    // since millis() doesn't work in static class, gotta use Java Timer class
    t.schedule(new TimerTask() {
      public void run() {
        stepTrigger();
      }
    }
    , (long) (tempo), (long) tempo);
  
  }
  
  public void stop(){
    sequencerShouldRun = false;
    t.cancel();
  }
  
  //public void update(){
  //  if(sequencerShouldRun){
  //    if(millis() - lastTime > tempo){
  //      stepTrigger();
  //    }
  //  }
  //}
  
  // gets & sets
  
  public int getNumberOfSequences(){
    return sequences.size();
  }
  
  public int getTempo(){
    return tempo;
  }
  
  
  // Sequence Class
  class Sequence {
    int[] s; // array for creating permutations
    int currentStep;
    boolean loop;
    
     Sequence(int _length){
        s = new int[_length];
        for (int i = 0; i < s.length; i++) {
          s[i] = i;
        }
        
        currentStep = 0;
        loop = true;
     }
     
     void reset(){
       currentStep = 0;
     }
     
     void next(){
       currentStep++;
       if(loop){
         if(currentStep >= s.length){
           reset();
         }
       }
     }
     
     int getCurrentStep(){
       if(currentStep <= s.length){
         return s[currentStep];
       } else {
         return -1;
       }
     }
  }

  
}

class Step implements SequencerListener{
  @Override
  public void nextStep(int step){
    println(step);
  }
  
}

class SoundUtilities  
// not sure how to make this just a bunch of helper functions,,
// maybe just add all the functions as a tab

{
  SoundUtilities(){
  }
  
  int midiToFreq(int m){
    return floor((pow(2, ((m-69)/12.0)))*440);
  }
  
  int freqToMidi(int f){
    return f;
  }
  
  int beatsToMillis(int b){
    return floor(1/(b/60) * 1000);
  }
  
  int millisToBeats(int m){
    return floor(1/(m/1000) * 60);
  }
  
}