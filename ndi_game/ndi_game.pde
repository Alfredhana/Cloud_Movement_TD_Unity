import oscP5.*;
import netP5.*;
import codeanticode.syphon.*;

private static final float IDEAL_FRAME_RATE = 30.0;

ObservableRect observableRect1;
ObservableRect observableRect2;
ObserverRect observerRect;

SyphonServer server;

OscP5 oscP5;
float rectWidth = 100;   // Width of the rectangles
float rectHeight = 50;   // Height of the rectangles

float rectX1;
float rectY1;
float rectX2;
float rectY2;

float rectStartX;  // X position of the first rectangle
float rectStartY;  // Y position of the first rectangle
float rect2X;  // X position of the second rectangle
float rect2Y;  // Y position of the second rectangle

float canvasWidth = 1200;
float canvasHeight = 800;

void setup() {
  size(1200, 800, P2D);
  
  rectMode(CENTER);
  
  server = new SyphonServer(this, "ProcessingServer");
  // Create an instance of OscP5 to receive OSC messages
  oscP5 = new OscP5(this, 7001);  // Adjust the port number as needed

  // Initialize the positions of the rectangles
  rectStartX = width / 2;    // Start at the center of the window
  rectStartY = height / 2;
  rect2X = rectStartX;       // Same initial position as rect1
  rect2Y = rectStartY;
  
  // Create instances of ObservableRect and ObserverRect
  observableRect1 = new ObservableRect(rectStartX, rectStartY, rectWidth, rectWidth, 255);
  observableRect2 = new ObservableRect(rectStartX, rectStartY, rectWidth, rectWidth, 0);
  observerRect = new ObserverRect(observableRect1, 0, 400);
}

void draw() {
  // Clear the background
  background(0);
  
  // Draw the rectangles
  // fill(255);
  observableRect1.update(rectX1, rectY1);
  observableRect1.display();
  
  observableRect2.update(rectX2, rectY2);
  observableRect2.display();
  
  //observerRect.update(0, -400);
  //observerRect.display();
  
  // Send the window frame to the Syphon server
  server.sendScreen();
}

void oscEvent(OscMessage message) {
  // Check if the OSC message is for updating circleX and circleY values
  if (message.checkAddrPattern("/circleX1")) {
    // Extract the values from the OSC message
    float receivedX = message.get(0).floatValue();
    
    // Update the circleX and circleY values
    rectX1 = receivedX;
  }
  if (message.checkAddrPattern("/circleY1")) {
    float receivedY = message.get(0).floatValue();
    rectY1 = receivedY;
  }
  
  if (message.checkAddrPattern("/circleX2")) {
    // Extract the values from the OSC message
    float receivedX = message.get(0).floatValue();
    
    // Update the circleX and circleY values
    rectX2 = receivedX;
  }
  if (message.checkAddrPattern("/circleY2")) {
    float receivedY = message.get(0).floatValue();
    rectY2 = receivedY;
  }
}


// ObservableRect class
class ObservableRect {
  public float x;            // X position of the rectangle
  public float y;            // Y position of the rectangle
  float velX;
  float velY;
  public float rectWidth;    // Width of the rectangle
  public float rectHeight;   // Height of the rectangle
  public int rectColor;      // Color of the rectangle
  float rotationAngle;
  
  ObservableRect(float x, float y, float rectWidth, float rectHeight, int rectColor) {
    this.x = x;
    this.y = y;
    this.rectWidth = rectWidth;
    this.rectHeight = rectHeight;
    this.rectColor = rectColor;
  }
  
  void update(float x, float y) {
    // Map the circleX and circleY values to the window dimensions
    float mappedX = map(x, 0, 1, 0, width);
    float mappedY = map(y, 0, 1, 0, height);
    
    // Update the position of the first rectangle gradually
    float easing = 0.05;   // Easing value for smooth movement
    float targetX = mappedX - rectWidth / 2;
    float targetY = mappedY - rectHeight / 2;
    float dx = targetX - this.x;
    float dy = targetY - this.y;
    this.velX = dx * easing;
    this.velY = dy * easing;
    
    // Check if the updated position goes beyond the left or right boundary
    if (this.x < this.rectWidth / 2) {
      this.x = this.rectWidth / 2;  // Reset x to the left edge
      this.velX = -0.5 * velX;  // Change velocity direction to go right
    } else if (targetX > width - rectWidth / 2) {
      this.x = width - rectWidth / 2;  // Reset x to the right edge
      this.velX = -0.5 * velX;  // Change velocity direction to go left
    }
  
    // Check if the updated position goes beyond the top or bottom boundary
    if (targetY < rectHeight / 2) {
      this.y = rectHeight / 2;  // Reset y to the top edge
      this.velY = -0.5 * this.velY;  // Change velocity direction to go down
    } else if (targetY > height - rectHeight / 2) {
      this.y = height - rectHeight / 2;  // Reset y to the bottom edge
      this.velY = -0.5 * this.velY;  // Change velocity direction to go up
    }
    
    rotationAngle += (0.1 + 0.04 * sqrt(this.x + this.y)) * PI / IDEAL_FRAME_RATE;
  }
  
  void display() {
    this.x += this.velX;
    this.y += this.velY;
    push();
      fill(this.rectColor);
      stroke(255);
      
      translate(this.x, this.y);
      push();
        rotate(this.rotationAngle);
        rect(0, 0, this.rectWidth, this.rectHeight);
      pop();
    pop();
  }
}

// ObserverRect class
class ObserverRect {
  ObservableRect observableRect;   // Reference to the observable rectangle
  float offsetX;          // Offset distance from the observable rectangle
  float offsetY;
  
  ObserverRect(ObservableRect observableRect, float offsetX, float offsetY) {
    this.observableRect = observableRect;
    this.offsetX = offsetX;
    this.offsetY = offsetY;
  }
  
  void update(float offsetX, float offsetY) {// Update the position of the second rectangle procedurally based on the first rectangle
    this.offsetX = offsetX;   // Offset distance from the first rectangle
    this.offsetY = offsetY;
  }
  
  void display() {
    float rectX = observableRect.x + this.offsetX;
    float rectY = observableRect.y + this.offsetY;
    rect(rectX, rectY, observableRect.rectWidth, observableRect.rectHeight);
  }
}
