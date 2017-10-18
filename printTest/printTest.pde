void setup(){
  size(100,100);
}
void draw(){
}
boolean[] a = {true, false, true, true, false, true, false, true, false, false, false, false, true, true, true, false, false, true};
boolean[] b = {true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, false, true, true, false, true, false, true, false, false, false, false, true, true, true, false, false, true };
void mouseClicked(){
saveBool(b);
}
void saveBool(String fileName, boolean[] b){
  byte[] toSave = new byte[b.length / 8 + 1];
  int counter = 0;
  int placeInByteArray = 0;
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