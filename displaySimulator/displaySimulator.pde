/*

This code is to test the actual display functions in processing. 
The display class is very barebones, and has the same functions as the hardware display.
The displayHelper class has all of the real functions. This is so that it can be directly ported to the arduino, without making any changes.

*/
int resx = 24;
int resy = 24;


displayHelper disp;

void setup(){
  disp = new displayHelper(new display(resx,resy));

  surface.setSize((int)disp.disp.screenSize().x, (int)disp.disp.screenSize().y);
}

void draw(){
  
  //disp.toggle((int)random(resx), (int)random(resy));
  //disp.toggle(2,2);
  delay(500);
  disp.update();
}
void mousePressed(){
  disp.loadData("test");
}

class displayHelper{
  boolean[][]data; //extra data to load onto screen
  boolean[][]screen;
  boolean isCurrent = false;
  
  display disp;
  displayHelper(display d){
    disp = d;
    screen = new boolean[d.resx][d.resy];
  }
  
  void update(){
    
    if(!isCurrent){
      background(100);
      disp.setScreen(screen);
      isCurrent = true;
    }
  }
  
  void toggle(int x, int y){
    if (x >= resx || x < 0 || y >= resy || y < 0) return;
    screen[x][y] = !screen[x][y];
    isCurrent = false;
  }
  
  
  void nyan(){
    //scroll nyan cat past
  }
  
  void staticPics(){
    //show like 10 static pictures
  }
  
  void mathAnimations(){
    //wooshy wooshy
  }
  
  void textScroll(){
    //some cool text and shit in here
  }
  void loadData(String filename){
    byte[] bytes = loadBytes(filename);
    if (bytes.length < 3){
      print("no data");
      return; //no data
    }
    if((bytes[0]*bytes[1] + 2) < bytes.length){
      print("invalid array");
      return;
    }
    print(bytes[0] + ", " + bytes[1] + " ");
    
    data = new boolean[bytes[0]][bytes[1]];
    int binCount = 16;
    for(int y = 0; y < bytes[1]; y++){
      for(int x = 0; x < bytes[0]; x++){
        if((bytes[binCount / 8] >> (7 - (binCount % 8)) & 1) == 1){
          print("true");
          data[x][y] = true;
        }
        binCount++;
      }      
    }
  screen = data;  
  isCurrent = false;
  }
  
  void clearScreen(boolean update){
    screen = new boolean[screen.length][screen[0].length];
    if(update)update();
  }
  
  void setScreen(int datx, int daty, int scrx, int scry){
    //sets screen to buffered data. Only does 1:1 because that's easy 
    //the x,y coordinates represent the top left corner
    
    
    
  }
}

class display{
  //  This class is "dumb". It only displays and does not know anything about itself.
  //boolean[][]data;
  
  int resx, resy;
  int radius;
  
  display(int x, int y){
//data = new boolean[x][y];
    resx = x;
    resy = y;
    radius = min(40, max(15, -1 * max(x,y) + 35));
  }
  PVector screenSize(){
    return new PVector(radius*resy*2, radius*resx*2);
  }
  
  void setScreen(boolean[][] b){
  //print(resx +" "+ resy);
    for(int x = 0; x < resx; x++){
      for(int y = 0; y < resy; y++){
        if(b[x][y]) {
          fill(200,0,0);
          ellipse(width*(x+1)/(resx + 1), height*(y+1)/(resy + 1), radius, radius);
          
        }
        else{
          
          fill(60, 60, 60);
          //ellipse(width*(x+1)/(resx + 1), height*(y+1)/(resy + 1), radius, radius);
        }
      }
    }
  }
}