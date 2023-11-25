
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
