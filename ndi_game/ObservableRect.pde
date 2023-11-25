
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
