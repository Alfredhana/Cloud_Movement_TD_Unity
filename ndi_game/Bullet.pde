
class Bullet {
  float x, y; // Position
  float velX, velY; // Target position
  float speed = .01; // Bullet speed
  float size;

  Bullet(float startX, float startY, float velX, float velY) {
    x = startX;
    y = startY;
    this.velX = velX;
    this.velY = velY;
    this.size = 30;
  }

  void update() {
    // Move the bullet towards the target with a fixed speed
    float vx = this.velX * speed;
    float vy = this.velY * speed;
    x += vx;
    y += vy;
  }

  void draw() {
    // Draw the bullet as a circle
    push();
      fill(255);
      ellipse(x, y, this.size, this.size);
    pop();
  }

  boolean collideBullet(Bullet other) {
    // Check for collision with another bullet
    float dx = other.x - x;
    float dy = other.y - y;
    float distance = sqrt(dx * dx + dy * dy);
    return distance < 10; // Assuming bullet radius is 10
  }
  
  boolean exceedsWindow() {
    // Check if the bullet exceeds the window bounds
    return x < 0 || x > width || y < 0 || y > height;
  }
}
