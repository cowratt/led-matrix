/*

display writer that allows user to draw things and save it to an arduino-readable format

save format is pretty simple. Starts at top left, writes left to right, top to bottom. Once it gets to the end of the frame, starts again with no buffer
byte 1: width
byte 2: height



1: prev frame
2:swaps with another frame
3 next frame
9: copy
0:paste

o: decrease size
p: increase size
l:toggle black dots


add lsh, rsh, ush, and dsh
add undo buffer of at least 5
add save!
properly seperate disp class and program. possible add a dispHandler class

oh and maybe add photo read or transparency

hide black leds button

*/
ArrayList<boolean[][]> frames = new ArrayList<boolean[][]>();
int currentFrame = 0;
int resx = 8;
int resy = 5;
int radius;
void setup(){
  radius = min(40, max(15, -1 * max(resx,resy) + 35));
  surface.setSize(radius*resx*2, radius*resy*2);
  frames.add(new boolean[resx][resy]);
  textSize(20);
  

  
}

disp d = new disp(resx,resy);

void draw(){
  background(100);
  fill(200);
  text(currentFrame, width/30, height/30);
  d.draw();
  
}
void keyPressed(){
  print(int(key));
  if(key == CODED){
    if(keyCode == LEFT) d.lsh();
    if(keyCode == RIGHT) d.rsh();
    if(keyCode == UP) d.ush();
    if(keyCode == DOWN) d.dsh();
  }
  if(key == '1'){
    if(currentFrame > 0){
      frames.set(currentFrame,  d.getData());
      currentFrame--;
      d.loadData(frames.get(currentFrame));
    }
  }
  if(key == '2') d.swapCanvas();
  if(key == '3'){
    if(currentFrame < 100 && !d.isEmpty()){
      frames.set(currentFrame,  d.getData());
      currentFrame++;
      if(frames.size() <=currentFrame) frames.add(new boolean[resx][resy]);
      d.loadData(frames.get(currentFrame));
    }
  }
  if(key == '9'){
    d.copy();
  }
  if(key == '0'){
    d.paste();
  }
  if(key == 'l') d.showBlack = !d.showBlack;
  if(key == 's')d.saveBool("test");
  
}

class disp{
  //(0,0) is top left
  boolean showBlack = true;
  boolean[][] data;
  boolean[][] data2;
  boolean[][] clip;
  int mode = 0;
  
  disp(int xwidth, int ywidth){
    data = new boolean[xwidth][ywidth];
    data2 = new boolean[xwidth][ywidth];
    clip = new boolean[xwidth][ywidth];
  }
  void draw(){
    if(!mousePressed) mode = 0;
    for(int i = 0; i < data.length; i++){
    for(int j = 0; j < data[i].length; j++){
      if(abs(mouseX - width*(i+1)/(data.length + 1)) < radius*2/3 && abs(mouseY - height*(j+1)/(data[i].length + 1)) < radius*2/3){
        fill(160,100,100);
        ellipse(width*(i+1)/(data.length + 1), height*(j+1)/(data[i].length + 1), radius, radius);
        if(mousePressed) toggle(i,j);
      }
      else if(data[i][j]){
        fill(200,0,0);
        ellipse(width*(i+1)/(data.length + 1), height*(j+1)/(data[i].length + 1), radius, radius);
      }
      //if(data[i][j]) ellipse(width*(i+1)/(data.length + 1), height*(j+1)/(data[i].length + 1), 20, 20);
      else{
        fill(0);
        ellipse(width*(i+1)/(data.length + 1), height*(j+1)/(data[i].length + 1), radius, radius);
      }
    }
  } 
  }
  void toggle(int x, int y){
    if(mode == 0){
      data[x][y] = !data[x][y];
      if(data[x][y]) mode = 2;
      else mode = 1;
    }
    else if(mode == 1) data[x][y] = false;
    else if(mode == 2) data[x][y] = true;
  }
  void setPt(int x, int y, boolean b){
    data[x][y] = b;
  }
  void setRow(int r, boolean b){
    for(int i = 0; i < data.length; i++) data[i][r] = b;
  }
  void setColumn(int c, boolean b){
    for(int i = 0; i < data[0].length; i++) data[c][i] = b;
  }
  void setAll(boolean b){
    for(int r = 0; r < data.length; r++){
      for(int c = 0; c < data[0].length; c++) data[r][c] = b;
    }
  }
  void loadData(boolean[][] b){
    data = b;
  }
  boolean[][]getData(){
    return data;
  }
  void swapCanvas(){
    boolean[][] temp = data;
    data = data2;
    data2 = temp;
  }
  void copy(){
    for(int r = 0; r < data.length; r++){
      for(int c = 0; c < data[0].length; c++) clip[r][c] = data[r][c];
    }
  }
  void paste(){
    for(int r = 0; r < data.length; r++){
      for(int c = 0; c < data[0].length; c++) data[r][c] = clip[r][c];
    }
  }
  boolean isEmpty(){
    for(int r = 0; r < data.length; r++){
      for(int c = 0; c < data[0].length; c++) if(data[r][c]) return false;
    }
    return true;
  }
  void lsh(){
    boolean[] temp = data[0];
    for(int i = 0; i < data.length-1; i++) data[i] = data[i+1];
    data[data.length-1] = temp;
  }
  void rsh(){
    boolean[] temp = data[data.length-1];
    for(int i = data.length-1; i > 0; i--) data[i] = data[i-1];
    data[0] = temp;
  }
  void ush(){
    for(int i = 0; i < data.length; i++){
      boolean temp = data[i][0];
      for(int j = 0; j < data.length-1; j++) data[i][j] = data[i][j+1];
      data[i][data.length-1] = temp;
    }
  }
  void dsh(){
    for(int i = 0; i < data.length; i++){
      boolean temp = data[i][data.length-1];
      for(int j = data.length-1; j > 0; j--) data[i][j] = data[i][j-1];
      data[i][0] = temp;
    }
  }
  void saveBool(String fileName){
    //make new array to save and transfer data over
    
    //CURRENT ISSUE IS LEAST SIGNIFICANT BIT IS NOT REGISTERING SOMETIMES
    
    
  boolean[] b = new boolean[data.length*data[0].length];
  for(int y = 0; y < data[0].length; y++)
    for(int x = 0; x < data.length; x++)
    
      b[y*(data.length - 1)+ x] = data[x][y];  
  
  byte[] toSave = new byte[b.length / 8 + 3];
  toSave[0] = (byte)data.length;
  toSave[1] = (byte)data[0].length;
  int counter = 0;
  int placeInByteArray = 2;
  byte tempByte = 0;
  
  //run until (b.length / 8) * 8 + 1 
  
  for(int i = 0; i < b.length; i++){
    if(counter >= 8){
      toSave[placeInByteArray] = tempByte;
      tempByte = 0;
      placeInByteArray++;
      counter = 0;
    }
    tempByte <<= 1;
    if(b[i]){
       print("yee"); 
      tempByte += 1;
    }
    counter++;
  }
  tempByte <<= (8-counter);
  toSave[placeInByteArray] = tempByte;
  saveBytes(fileName, toSave);
}

}