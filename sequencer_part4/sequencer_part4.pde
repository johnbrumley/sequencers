/*

Loading in Patterns from a file

*/

Sequencer sequencer;

void setup(){
  sequencer = new Sequencer();
  loadPatternsFromFile("patterns.json");
}

void draw(){
}


void loadPatternsFromFile(String fileName){
  JSONObject json = loadJSONObject(fileName);

  JSONArray values = json.getJSONArray("patterns");
  
  int[] p;
  for (int i = 0; i < values.size(); i++) {
    
    JSONObject pattern = values.getJSONObject(i);
    
    String name = pattern.getString("name");
    JSONArray patternValues = pattern.getJSONArray("pattern");
    
    p = new int[patternValues.size()];
    println(patternValues.size());
    println(p[0]);
    for(int j = 0; j < p.length; j++){
      p[j] = patternValues.getInt(j);
    }
    
    
    sequencer.addPattern(name, p);
    
  }
  
  
}


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