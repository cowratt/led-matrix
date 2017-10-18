//Pin connected to ST_CP of 74HC595
int latchPin = 8;
//Pin connected to SH_CP of 74HC595
int clockPin = 12;
////Pin connected to DS of 74HC595
int dataPin = 11;



void setup() {
  //set pins to output so you can control the shift register
  pinMode(latchPin, OUTPUT);
  pinMode(clockPin, OUTPUT);
  pinMode(dataPin, OUTPUT);
  Serial.begin(9600);
}

void loop() {
  // count from 0 to 255 and display the number 
  // on the LEDs
  int out = 1;
  for(int i = 0; i < 7; i++){
    digitalWrite(latchPin, LOW);
    out <<= 1;
    out += 1;
    Serial.print(out);
    shiftOut(dataPin, clockPin, MSBFIRST, out);
    digitalWrite(latchPin, HIGH);
    delay(200);
  }
  out <<= 1;
  for(int i = 0; i < 8; i++){
    digitalWrite(latchPin, LOW);
    out <<= 1;
    Serial.print(out);
    shiftOut(dataPin, clockPin, MSBFIRST, out);
    digitalWrite(latchPin, HIGH);
    delay(200);
  }

}
/*
  
  for (int numberToDisplay = 0; numberToDisplay < 256; numberToDisplay++) {
    // take the latchPin low so 
    // the LEDs don't change while you're sending in bits:
    digitalWrite(latchPin, LOW);
    // shift out the bits:
    shiftOut(dataPin, clockPin, MSBFIRST, numberToDisplay);  

    //take the latch pin high so the LEDs will light up:
    digitalWrite(latchPin, HIGH);
    // pause before next value:
    delay(50);
  }
}
*/
