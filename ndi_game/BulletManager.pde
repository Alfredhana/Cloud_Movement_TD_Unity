class BulletManager {
  ArrayList<Bullet> bullets;

  float rectX1 = 100;
  float rectY1 = 200;
  float rectW1 = 50;
  float rectH1 = 50;

  float rectX2 = 600;
  float rectY2 = 200;
  float rectW2 = 50;
  float rectH2 = 50;
  ObservableRect rect1;
  ObservableRect rect2;
  long lastBulletTime = 0;
  final int FIRE_COOLDOWN = 1000;

  BulletManager(ObservableRect rect1, ObservableRect rect2) {
    bullets = new ArrayList<Bullet>();
    this.rect1 = rect1;
    this.rect2 = rect2;
  }
  
  Boolean checkCollide() {
    ArrayList<Integer> bulletsToRemove = new ArrayList<>();
    // Update the bullets
    for (int i = 0; i < bullets.size() - 1; i++) {
      Bullet bulletA = bullets.get(i);
      
      Boolean hasCollide = false;
      for (int j = i + 1; j < bullets.size(); j++) {
        println(i);
        println(j);
        println(getTotalBullets());
        Bullet bulletB = bullets.get(j);
        if (bulletA.collideBullet(bulletB)) {
          hasCollide = true;
          bulletsToRemove.add(i);
          bulletsToRemove.add(j);
          break;
        }
      }
      // Check for collision with the rectangles or exceeding the window
      if (!hasCollide && bulletA.exceedsWindow()) {
        bulletsToRemove.add(i);
      }
    }
    
    // Remove bullets outside the loop
    for (int i = bulletsToRemove.size() - 1; i >= 0; i--) {
      int index = bulletsToRemove.get(i);
      bullets.remove(index);
    }
    
    println("Bullet Manager Check Collide");
    
    return !bulletsToRemove.isEmpty();
  }

  void update(){
    for (Bullet bullet : bullets) {
      bullet.update();
    }
    println("Bullet Manager Update");
  }

  void draw() {
    // Draw the bullets
    for (Bullet bullet : bullets) {
      bullet.draw();
    }
    println("Bullet Manager Draw");
  }
  
  void checkFire(){
    long currentTime = System.currentTimeMillis();
    if (currentTime - lastBulletTime >= FIRE_COOLDOWN) {
      ObservableRect rectLeft = this.rect1.x >= this.rect2.x ? this.rect1 : this.rect2;
      ObservableRect rectRight = this.rect1.x < this.rect2.x ? this.rect1 : this.rect2;
      this.fireBullet(rectLeft.x, rectLeft.y, rectRight.x - rectLeft.x, rectRight.y - rectLeft.y);
      this.fireBullet(rectRight.x, rectRight.y, rectLeft.x - rectRight.x, rectLeft.y - rectRight.y);
      lastBulletTime = currentTime; // Update the last bullet time
    }
    println("Bullet Manager Check Fire");
  }

  void fireBullet(float startX, float startY, float velX, float velY) {
    Bullet bullet = new Bullet(startX, startY, velX, velY);
    bullets.add(bullet); // Add the bullet to the ArrayList
  }

  int getTotalBullets() {
    return bullets.size();
  }
}
