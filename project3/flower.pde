// Flower class
class Flower {
  float x, y;
  float size;
  
  Flower(float x, float y, float size) {
    this.x = x;
    this.y = y;
    this.size = size;
  }
  
  void update() {
    size += growthRate; // Increase the size of the flower
  }
  
  void draw(PGraphics pg) {
    pg.noFill();
    pg.stroke(255);
    pg.strokeWeight(2);
    
    // Draw petals as circles around the center
    int numPetals = 12;
    float petalRadius = size / 4;
    for (int i = 0; i < numPetals; i++) {
      float angle = TWO_PI / numPetals * i;
      float petalX = x + cos(angle) * size;
      float petalY = y + sin(angle) * size;
      pg.ellipse(petalX, petalY, petalRadius, petalRadius);
    }
    
    // Draw the center of the flower
    pg.ellipse(x, y, size / 2, size / 2);
  }
}
