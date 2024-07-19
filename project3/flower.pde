// Flower class
class Flower {
  float x, y;
  float size;
  float opacity;
  
  Flower(float x, float y, float size) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.opacity = 255; // Start fully opaque
  }
  
  void update() {
    size += growthRate; // Increase the size of the flower
    opacity -= 2; // Decrease opacity to create fade-out effect
    if (opacity < 0) opacity = 0; // Ensure opacity does not go below 0
  }
  
  void draw(PGraphics pg) {
    pg.noFill();
    pg.stroke(255, opacity); // Use opacity for fading effect
    pg.strokeWeight(20);
    
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
