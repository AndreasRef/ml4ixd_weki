/*
  Run this sketch along with "ProcessingSerialToWekinator" to send analog inputs from
  Arduino to Wekinator via Processing for classification/regression/dtw 
 */

void setup() {
  // initialize serial communication at 9600 bits per second:
  Serial.begin(9600);
}

void loop() {
  // read the input on analog pin 0:
  int sensorValue = analogRead(A0);
  // print out the value you read:
  Serial.println(sensorValue);
  delay(1);        // delay in between reads for stability

  /*
  //If you want to send multiple values from multiple analog inputs 
  //then do something along the line of this instead:
  Serial.print(A0);
  Serial.print(",");
  Serial.print(A1);
  Serial.print(",");
  Serial.println(A2);
  */
}
