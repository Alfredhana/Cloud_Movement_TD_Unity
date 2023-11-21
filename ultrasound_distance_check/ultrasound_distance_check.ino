
void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(5, OUTPUT);
  pinMode(4, INPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
  
  digitalWrite(5, LOW);
  delayMicroseconds(2);
  digitalWrite(5, HIGH);
  delayMicroseconds(10);
  digitalWrite(5, LOW);
  float distance = pulseIn(4, HIGH);
  
  delay(40);
  Serial.print(distance);
  Serial.print(" ");
}
