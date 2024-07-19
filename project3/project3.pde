import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer song;
FFT fft;
BeatDetect beatDetect;

PImage backgroundImg;
PGraphics maskImg;

int bands = 128;
float[] spectrum = new float[bands];

int beatCounter = 0;
int beatsPerMeasure = 4;
float beatsPerMinute = 120; // Adjust this value to match the tempo of your song
float measureDuration; // Duration of a measure in milliseconds
float lastBeatTime = 0;

// Variables for the flower animation
float flowerSize = 0;
float maxFlowerSize = 200;
float growthRate = 2; // How quickly the flower grows
boolean flowerVisible = false;
float flowerX, flowerY;

void setup() {
  strokeWeight(5);
  size(800, 800);
  backgroundImg = loadImage("flowers.jpg");
  backgroundImg.resize(width, height);
  
  // Create a mask image
  maskImg = createGraphics(width, height);
  
  // Initialize Minim and load the song
  minim = new Minim(this);
  song = minim.loadFile("just.mp3", 1024);
  song.play();
  
  // Initialize FFT and BeatDetect
  fft = new FFT(song.bufferSize(), song.sampleRate());
  beatDetect = new BeatDetect(song.bufferSize(), song.sampleRate());

  // Calculate measure duration based on beats per minute
  measureDuration = 60000.0 / beatsPerMinute * beatsPerMeasure;
}

void draw() {
  // Clear the mask image
  maskImg.beginDraw();
  maskImg.background(0);
  
  // Perform a forward FFT on the samples in the mix
  fft.forward(song.mix);
  beatDetect.detect(song.mix);
  
  // Get current time in milliseconds
  float currentTime = millis();
  
  // Check if it's time to update the flower
  if (beatDetect.isKick() && (currentTime - lastBeatTime > measureDuration / beatsPerMeasure)) {
    lastBeatTime = currentTime;
    beatCounter++;
    
    // Start a new flower reveal at a random position
    flowerX = random(width);
    flowerY = random(height);
    flowerSize = 0;
    flowerVisible = true;
  }
  
  // Draw the flower animation if it's visible
  if (flowerVisible) {
    drawFlower(flowerX, flowerY, flowerSize);
    flowerSize += growthRate; // Increase the size of the flower
    if (flowerSize > maxFlowerSize) {
      flowerVisible = false; // Stop drawing the flower when it reaches max size
    }
  }
  
  maskImg.endDraw();
  
  // Apply the mask to the background image
  PImage maskedImage = backgroundImg.copy();
  maskedImage.mask(maskImg.get());
  
  // Draw the white background
  background(255);
  
  // Draw the masked image
  image(maskedImage, 0, 0, width, height);
}

void drawFlower(float x, float y, float size) {
  // Draw flower shape (a simple flower with petals)
  maskImg.noFill();
  maskImg.stroke(255);
  maskImg.strokeWeight(5);
  
  // Draw petals in a flower shape
  int numPetals = 6;
  float petalLength = size / 2;
  for (int i = 0; i < numPetals; i++) {
    float angle = TWO_PI / numPetals * i;
    float petalX = x + cos(angle) * size;
    float petalY = y + sin(angle) * size;
    maskImg.line(x, y, petalX, petalY);
  }
  
  // Draw the center of the flower
  maskImg.ellipse(x, y, size / 2, size / 2);
}

void stop() {
  song.close();
  minim.stop();
  super.stop();
}
