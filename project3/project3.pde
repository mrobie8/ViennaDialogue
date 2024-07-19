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
float beatsPerMinute = 118; // Adjust this value to match the tempo of your song
float measureDuration; // Duration of a measure in milliseconds
float lastBeatTime = 0;

// Flower parameters
ArrayList<Flower> flowers;
float maxFlowerSize = 200;
float growthRate = 2; // How quickly the flower grows

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

  // Initialize flowers list
  flowers = new ArrayList<Flower>();
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
  
  // Check if it's time to add a new flower
  if (beatDetect.isKick() && (currentTime - lastBeatTime > measureDuration / beatsPerMeasure)) {
    lastBeatTime = currentTime;
    
    // Add a new flower at a random position
    float flowerX = random(width);
    float flowerY = random(height);
    flowers.add(new Flower(flowerX, flowerY, 0));
  }
  
  // Update and draw all flowers
  for (int i = flowers.size() - 1; i >= 0; i--) {
    Flower flower = flowers.get(i);
    flower.update();
    flower.draw(maskImg);
    
    // Remove flowers that are fully faded
    if (flower.opacity <= 0) {
      flowers.remove(i);
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


void stop() {
  song.close();
  minim.stop();
  super.stop();
}
