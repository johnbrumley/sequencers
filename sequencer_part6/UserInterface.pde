import de.bezier.guido.*;

String[] patternNames;
PatternButton[] patternButtons;

int rowLength;
int columnLength;

void setupUI(){
    Interactive.make( this );
    
    // create some buttons
    
    int w = (width-20)/10;

    patternNames = seq.getAllPatternNames();
    rowLength = (width-20)/(2*w);
    columnLength = (height-20)/(2*w);
    patternButtons = new PatternButton[rowLength*columnLength];
    
    int counter = 0;
    for(int ix = 20, k = width-w; ix <= k; ix += 2*w){
      for(int iy = 20, n = height-w; iy <= n; iy += 2*w){
        patternButtons[counter] = new PatternButton(patternNames[floor(random(patternNames.length))],ix,iy,w,w);
        new AddSubtractButton(patternButtons[counter],ix-w/4,iy-w/4);
        
        counter++;
      }
    }    
}

void drawUI(){
  for(int i = 0; i < patternButtons.length; i++){
    if(i%5 == 0 && patternButtons[i].invisible){
      patternButtons[i].setVisible();
      if(!patternButtons[i].active){
        patternButtons[i].setActive();
      }
    }
    if(i > 0){
      if(patternButtons[i-1].active && patternButtons[i].invisible){
        patternButtons[i].setVisible();
      } else if(!patternButtons[i-1].active && !patternButtons[i].invisible && !patternButtons[i].active){
        patternButtons[i].setVisible();
      }
    }
    

    if(patternButtons[i].active && !patternButtons[i].subtractable){
      patternButtons[i].subtractable = true;
    }

  }
}

public class PatternButton
{
  float x, y, width, height;
  String patternName;
  boolean active = false;
  boolean invisible = true;
  boolean subtractable = false;
  
  PatternButton(String name, float xx, float yy, float w, float h){
    x = xx; y = yy; width = w; height = h;
    patternName = name;
   
    Interactive.add( this );
  }
  
  void setActive(){
    active = !active;
  }
  
  void setVisible(){
    invisible = !invisible;
  }
  
  void mousePressed() {
    // change patternName on button
    String nextPatternName = patternNames[0];
    for(int i = 0; i < patternNames.length; i++){
     if(patternNames[i].equals(patternName) && i != patternNames.length-1){
       nextPatternName = patternNames[i+1];
     }
    }
    patternName = nextPatternName;
  }
  
  void draw(){
    if(!invisible){
      if(active){
        // draw button back and write pattern name on button
        fill(255);
        rect(x, y, width, height);
        
        // draw progress of pattern
        int currentState = seq.getStep(patternName);
        int currentLength = seq.getEntirePattern(patternName).length;
        float percent = (float)currentState/(currentLength-1);
        
        fill(150);
        noStroke();
        rect(x,y,percent*width,height);
        
        textSize(height - (height/5));
        textAlign(CENTER,TOP);
        
        fill(100);
        // chop if too long
        String displayName = patternName;
        if(displayName.length() > 4) displayName = displayName.substring(0,5);
        text(displayName,x+width/2,y);
      } else {
        fill(50);
        rect(x, y, width, height);
      }
    }
  }
}

public class AddSubtractButton {
  float x, y, width, height;
  PatternButton parent;
  String type = "add";
  AddSubtractButton(PatternButton b, float xx, float yy){
    x = xx; y = yy;
    
    width = 10;
    height = 10;
    
    parent = b;
    
    Interactive.add( this );
  }
  
  void mousePressed(){
    if(!parent.invisible && !parent.active || parent.subtractable){
      if(type.equals("add")){
        type = "subtract";
      } else {
        type = "add";
      }
      // change parent to active
      parent.setActive();
    }
  }
  
  void draw(){
    if(!parent.invisible && !parent.active || parent.subtractable){
      if(parent.subtractable && type.equals("add")){
        type = "subtract";
      }
      noStroke();
      fill(255);
      ellipseMode(CORNER);
      ellipse(x, y, width, height);
      stroke(100);
      if(type.equals("add")){
        line(x,y+height/2,x+width,y+height/2);
        line(x+width/2,y,x+width/2,y+height);
      } else {
        line(x,y+height/2,x+width,y+height/2);
      }
    }
  }
}