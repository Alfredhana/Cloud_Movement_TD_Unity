import oscP5.*;
import netP5.*;
//import codeanticode.syphon.*;  // Comment out the Syphon import
import spout.*;  // Add the Spout import
import java.util.HashMap;
import java.lang.Object;

private static final float IDEAL_FRAME_RATE = 30.0;

ObservableRect observableRect1;
ObservableRect observableRect2;
ObserverRect observerRect;

BulletManager bulletManager;

//SyphonServer server;  // Comment out the SyphonServer declaration

Spout spout;  // Add the Spout declaration

OscP5 oscP5;
NetAddress oscSend;
float rectWidth = 100;   // Width of the rectangles
float rectHeight = 50;   // Height of the rectangles

float rectStartX;  // X position of the first rectangle
float rectStartY;  // Y position of the first rectangle
float rect2X;  // X position of the second rectangle
float rect2Y;  // Y position of the second rectangle

HashMap<String, Float> oscValues;

float canvasWidth = 1200;
float canvasHeight = 800;
Boolean isStarted = false;
float prevGap = -1;
float prevGapThreshold = 0.12; // Magic Number, Don't Ask

void setup() {
  size(1200, 800, P2D);
   
  // Set the blend mode to achieve blending effect
  blendMode(ADD);
  rectMode(CENTER);
  
  //server = new SyphonServer(this, "ProcessingServer");
  spout = new Spout(this);  // Initialize the Spout object
  spout.setSenderName("ProcessingServer");
  
  oscP5 = new OscP5(this, 7001);  // Adjust the port number as needed
  oscSend = new NetAddress("127.0.0.1", 7002);

  // Initialize the dictionary for OSC values
  oscValues = new HashMap<String, Float>();
  
  rectStartX = width / 2;
  rectStartY = height / 2;
  rect2X = rectStartX;
  rect2Y = rectStartY;
  
  observableRect1 = new ObservableRect(rectStartX / 2, rectStartY, rectWidth, rectWidth, 255);
  observableRect2 = new ObservableRect(rectStartX * 2, rectStartY, rectWidth, rectWidth, 150);
  observerRect = new ObserverRect(observableRect1, 0, 400);
  
  // Instantiate the bullet manager
  bulletManager = new BulletManager(observableRect1, observableRect2);
}

void draw() {
  background(0);
  testSendOSCMessage();
  
  //if (!isStarted || prevGap <= 0){
  //  prevGap = abs(oscValues.getOrDefault("rectX2", 1.0) - oscValues.getOrDefault("rectX1", 1.0));
  //  isStarted = prevGap > prevGapThreshold ? true : false;
  //}
  
  //float rectX1 = 0.2;
  //float rectY1 = 0.6;
  //float rectX2 = 0.8;
  //float rectY2 = 0.6;
  
  //if (isStarted){
  
  //  rectX1 = oscValues.getOrDefault("rectX1", 0.5);
  //  rectY1 = oscValues.getOrDefault("rectY1", 0.5);
  //  rectX2 = oscValues.getOrDefault("rectX2", 0.5);
  //  rectY2 = oscValues.getOrDefault("rectY2", 0.5);

  //  // Update the window size based on the OSC values
  //  float shoulderLX = oscValues.getOrDefault("shoulderLX", 1.0);
  //  float shoulderLY = oscValues.getOrDefault("shoulderLY", 1.0);
  //  float shoulderRX = oscValues.getOrDefault("shoulderRX", 1.0);
  //  float shoulderRY = oscValues.getOrDefault("shoulderRY", 1.0);
  //  float hipX = oscValues.getOrDefault("hipX", 1.0);
  //  float hipY = oscValues.getOrDefault("hipY", 1.0);
    
  //  // Calculate the dimensions of the rectangle based on shoulderX and shoulderY
  //  float rectWidth = map(abs(shoulderRX - shoulderLX), 0, 1, 0.4, 0.6) * canvasWidth;
  //  float rectHeight = map(abs(shoulderRY - hipY), 0, 1, 0.3, 0.5) * canvasHeight * 0.9;
  
  //  // Draw the rectangle at the center of the window
  //  float bigRectX = map(shoulderLX, 0, 1, 0.2, 0.8) * canvasWidth;
  //  float bigRectY = map(shoulderLY, 0, 1, 0.2, 0.8) * canvasHeight;
    
  //  push();
  //    fill(100);
  //    rect(bigRectX, bigRectY, rectWidth, rectHeight);
  //  pop();
    
  //  bulletManager.checkFire();
  //  bulletManager.update();
  //  // Update and draw the bullets
  //  if (bulletManager.checkCollide()){
  //    OscMessage msg = new OscMessage("/collided");
  //    msg.add(1);
  //    sendOSCMessage(msg);
  //    print("collided");
  //  }
  //  bulletManager.draw();
  //}
  
  //observableRect1.update(rectX1, rectY1);
  //observableRect1.display();
  
  //observableRect2.update(rectX2, rectY2);
  //observableRect2.display();
  
  //// Send the window frame to the Spout framework
  //spout.sendTexture();  // Replace server.sendScreen() with spout.sendTexture()
  
  //server.sendScreen();
}

void oscEvent(OscMessage message) {
  String address = message.addrPattern(); // Extract the OSC address pattern
  address = address.substring(1); // Remove the leading "/"

  // Check if the address is valid and update the corresponding value in the dictionary
  if (address != null && !address.isEmpty()) {
    float value = message.get(0).floatValue();
    oscValues.put(address, value);
  }
}

void sendOSCMessage(OscMessage msg){
  oscP5.send(msg, oscSend);
}

long lastBulletTime = 0;
final int FIRE_COOLDOWN = 5000;

void testSendOSCMessage(){
  long currentTime = System.currentTimeMillis();
  OscMessage msg = new OscMessage("/collided");
  if (currentTime - lastBulletTime >= FIRE_COOLDOWN) {
    msg.add("bang");
    lastBulletTime = currentTime;
  }
  if (currentTime - lastBulletTime < FIRE_COOLDOWN / 4) {
    msg.add(0);
  }
  sendOSCMessage(msg);
}


void keyPressed() {
  if (key == 'q' || key == 'Q') {
    exit(); // Exit the program when 'q' or 'Q' key is pressed
  }
}
