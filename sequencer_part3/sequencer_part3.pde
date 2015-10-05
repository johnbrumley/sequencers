import processing.sound.*;

/* 

So far we've only been able to store one type of value for
each pattern that we make. What if you want to keep track
of both pitch and volume for each note of the sequence? Instead
of creating an array of just integers, we can create an array
of custom objects that store multiple values.

*/

// Here is our custom Note class, our Sequencer is expecting patterns
// containing Note objects
class Note {
  int freq; // store the frequency
  float vol; // store the volume
  char letter; // you can store whatever you want
  
  Note(int _freq, float _vol, char _letter){
    freq = _freq;
    vol = _vol;
    letter = _letter;
  }
}

Sequencer seq;
Note[] pattern;

void setup(){
  
  seq = new Sequencer();
  seq.setTempo(150);
  
  pattern = new Note[8];
  char[] chars = "l8trdude".toCharArray();
  float f = 0.0;
  for(int i=0; i < pattern.length;i++){
    int randomPitch = floor(random(40,60));
    
    pattern[i] = new Note(randomPitch, f, chars[i]);
    
    f += 0.1;
    if(f > 1.0){
      f = 0;
    }
  }
  
  seq.newPattern("p1", pattern);
}

void draw(){
  if(seq.checkState()){
    Note currentNote = seq.getState("p1");
    print("pitch: " + currentNote.freq + " ");
    print("vol: " + currentNote.vol + " ");
    print("secret message: " + currentNote.letter);
    println();
  }
}