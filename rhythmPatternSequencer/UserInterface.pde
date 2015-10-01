// Classes that define the user interface elements, using Florian's GUIdo library

import de.bezier.guido.*;

public class CheckBox
{
    boolean checked;
    boolean active;
    boolean muted;
    float x, y, width, height;
    
    CheckBox (float xx, float yy, float ww, float hh )
    {
        x = xx; y = yy; width = ww; height = hh;
        Interactive.add( this );
    }
    
    void mouseReleased ()
    {
        checked = !checked;
    }
    
    void draw ()
    {
        noStroke();
        fill( 120 );
        rect( x, y, width, height );
        
        if ( active && !checked ) 
        {
          
          fill( #F4A8FC );
          if(muted) fill(130);
          rect( x+2, y+2, width-4, height-4 );
        }
        
        if ( checked && !active)
        {
            fill( #2EFFD7 );
            if(muted) fill(150);
            rect( x+2, y+2, width-4, height-4 );
        }
        
        if ( checked && active)
        {
            fill( #D0FF93 );
            if(muted) fill(170);
            rect( x+2, y+2, width-4, height-4 );
        }
    }
    
    boolean isChecked(){
      return checked;
    }
    
    void setActive(boolean value){
      active = value;
    }
    
    void setMute(boolean value){
      muted = value;
    }
}

// something didn't work when extending CheckBox, so defining from scratch
public class CircleToggle {
   boolean checked = true;
   float x, y, width, height;
   CircleToggle(float xx, float yy, float ww, float hh ){
     x = xx; y = yy; width = ww; height = hh;
     Interactive.add( this );
     ellipseMode(CORNER);
   }
 
   void mouseReleased ()
    {
      checked = !checked;
    }
  
    boolean isChecked(){
      return checked;
    }
 
   void draw ()
    {
        noStroke();
        fill( #B7B7B7 );
        
        ellipse( x, y, width, height );
        
        if ( checked ) 
        {
          fill( #F5F5F5 );
          ellipse( x, y, width, height);
        }
       
    }
}

public class Slider
{
    float x, y, width, height;
    float valueX = 0, value;
    PFont f;
    
    Slider ( float xx, float yy, float ww, float hh ) 
    {
        x = xx; 
        y = yy; 
        width = ww; 
        height = hh;
        
        valueX = width/2;
        value = map( valueX, x, x+width-height, 0, 1 );
    
        // register it
        Interactive.add( this );
        
        f = createFont("SourceCodePro-Regular.vfw", 24);
        textFont(f);
        textAlign(RIGHT, TOP);
        textSize(height);
    }
    
    // called from manager
    void mouseDragged ( float mx, float my )
    {
        valueX = mx - height/2;
        
        if ( valueX < x ) valueX = x;
        if ( valueX > x+width-height ) valueX = x+width-height;
        
        value = map( valueX, x, x+width-height, 0, 1 );
    }

    void draw () 
    {
        noStroke();
        
        fill( 100 );
        rect(x, y, width, height);
        
        fill( 120 );
        rect( valueX, y, height, height );
        
        text(millisToBeats(value*1000 + 50), width, 0);
    }
}

// convert milliseconds to beats per minute
int millisToBeats(float m){
  return floor((1/(m/1000)) * 60);
}