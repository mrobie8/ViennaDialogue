interface Shape {
  void update();
  void draw(PGraphics pg);
  float getOpacity();
}

//circle class
class Circle implements Shape {
  float x, y;
  float size;
  float opacity;
  float thickness;
  
  Circle(float x, float y, float size) {
   this.x = x;
   this.y = y;
   this.size = size;
   this.opacity = random(200, 255);
   this.thickness = random(2, 10);
  }
  
  void update() {
    size += 2;
    opacity -= growthRate;
    if (opacity < 0) opacity = 0;
  }
  
  void draw(PGraphics pg) {
    pg.noFill();
    pg.stroke(255, opacity);
    pg.strokeWeight(thickness);
    pg.ellipse(x, y, size / 4, size / 4);
  }
  
  float getOpacity() {
    return this.opacity; 
  }
}

// Flower class
class Flower implements Shape {
  float x, y;
  float size;
  float opacity;
  
  Flower(float x, float y, float size) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.opacity = 255; 
  }
  
  // increase the size of the flower, decrease opacity to create fade-out effect
  void update() {
    size += growthRate; 
    opacity -= 2; 
    if (opacity < 0) opacity = 0; 
  }
  
  void draw(PGraphics pg) {
    pg.noFill();
    pg.stroke(255, opacity); 
    pg.strokeWeight(23);
    
    // Draw petals as circles around the center
    int numPetals = 12;
    float petalRadius = size / 4;
    for (int i = 0; i < numPetals; i++) {
      float angle = TWO_PI / numPetals * i;
      float petalX = x + cos(angle) * size;
      float petalY = y + sin(angle) * size;
      pg.ellipse(petalX, petalY, petalRadius, petalRadius);
    }
    pg.ellipse(x, y, size / 2, size / 2);
  }
  
  float getOpacity() {
    return this.opacity; 
  }
}
