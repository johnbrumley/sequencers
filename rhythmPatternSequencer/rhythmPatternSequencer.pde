import de.bezier.guido.*;

CheckBox[] boxes;
int gridWidth;
int gridHeight;
int currentStep = 0;
int tempo = 500;
int lastTime = 0;

void setup ()
{
    size( 450, 250 );
    
    Interactive.make(this);
    
    gridWidth = ((width-50)/25);
    gridHeight = ((height-50)/25);
    boxes = new CheckBox[ gridWidth * gridHeight];
    int currentBox = 0;
    for ( int i = 0; i < height-50; i+= 25 ) {
      for( int j = 0; j < width-50; j+= 25 ) {
        boxes[currentBox] = new CheckBox(25+j, 25+i, 24, 24 );
        currentBox++;
      } 
    }
    
    lastTime = millis();
}

void draw ()
{
    background( 20 );
    
    // check which boxes are checked
    for (int i = 0; i < boxes.length; i++) {
      if(i%gridWidth == currentStep){
        boxes[i].setActive(true);
      } else {
        boxes[i].setActive(false);
      }
      
      if(boxes[i].isChecked()){
        //println("Box #" + i + " is checked");
      }
    }
    
    if(millis() - lastTime > tempo){
      currentStep++;
      if(currentStep >= gridWidth){
        currentStep = 0;
      }
      lastTime = millis();
    }
}

public class CheckBox
{
    boolean checked;
    boolean active;
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
          rect( x+2, y+2, width-4, height-4 );
        }
        
        if ( checked && !active)
        {
            fill( #2EFFD7 );
            rect( x+2, y+2, width-4, height-4 );
        }
        
        if ( checked && active)
        {
            fill( #D0FF93 );
            rect( x+2, y+2, width-4, height-4 );
        }
    }
    
    boolean isChecked(){
      return checked;
    }
    
    void setActive(boolean value){
      active = value;
    }
}