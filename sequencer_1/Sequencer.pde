import java.util.*;

// Interface for our Event Listener 
interface SequencerListener {
  void nextStep(int[] step);
}

// Sequencer Class, holds a list of sequences and timers
static class Sequencer {

  final Timer t = new Timer(); // uses Java Timer class as our clock
  
  private ArrayList<SequencerListener> listeners = new ArrayList<SequencerListener>();
  private ArrayList<Sequence> sequences = new ArrayList<Sequence>();
  
  int tempo;
  int lastTime;
  
  private Sequencer() {
    super();
    
    tempo = 500;
  }
  
  // Singleton stuff, maybe not necessary
  private static class SingletonHolder { 
     private static final Sequencer INSTANCE = new Sequencer();
  }
  
  public static Sequencer getInstance() {
    return SingletonHolder.INSTANCE;
  }
  
  // Event listener add function
  public void addListener(SequencerListener toAdd){
    listeners.add(toAdd);
  }
  
  // function to run with each step
  public void stepTrigger() {
    // notify all listeners
    for (SequencerListener sl : listeners) {
      // populate array of all the current indices
      int[] currentSteps = new int[sequences.size()];
      for (int i = 0; i < currentSteps.length; i++) {
        currentSteps[i] = sequences.get(i).getCurrentStep();
        // advance each sequence
        sequences.get(i).next();
      }
      // send the new steps to our listeners
      sl.nextStep(currentSteps);
    }
  }
  
  // adding new sequences
  public void addSequence(int lengthOfSeq){
    sequences.add(new Sequence(lengthOfSeq));
  }
  
  // Starting the sequencer
  public void startSequencer(){
    // create a new timer
    t.schedule(new TimerTask() {
      // function that will be called each time
      public void run() {
        stepTrigger();
      }
    }
    , (long) (tempo), (long) tempo); // delay and time between 
  }
  
  // stop sequencer
  public void stop(){
    t.cancel();
  }
  
  // gets & sets
  
  public int getNumberOfSequences(){
    return sequences.size();
  }
  
  public int getTempo(){
    return tempo;
  }
  
  
  // Sequence Class, handles individual sequences and related logic
  class Sequence {
    int[] s;
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
       // make sure current step is within range, in case not looping
       if(currentStep <= s.length){
         return s[currentStep];
       } else {
         return -1;
       }
     }
  }
}


// some utils
class SoundUtilities  

{
  SoundUtilities(){
  }
  
  int midiToFreq(int m){
    return floor((pow(2, ((m-69)/12.0)))*440);
  }
  
  int beatsToMillis(int b){
    return floor(1/(b/60) * 1000);
  }
  
  int millisToBeats(int m){
    return floor(1/(m/1000) * 60);
  }
  
}