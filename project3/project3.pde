import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer song;
FFT fft;
BeatDetect beatDetect;
PImage backgroundImg;
PGraphics maskImg;
int beatsPerMeasure = 4;
float beatsPerMinute = 118; 
float measureDuration = 60000.0 / beatsPerMinute * beatsPerMeasure; 
float lastBeatTime = 0;
ArrayList<Shape> shapes;
float growthRate = 2; 

void setup() {
  size(800, 800);
  backgroundImg = loadImage("sketch.jpg");
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

  shapes = new ArrayList<Shape>();
}

void draw() {
  // Clear the mask image
  maskImg.beginDraw();
  maskImg.background(0);
  
  // Perform a forward FFT on the samples in the mix
  fft.forward(song.mix);
  beatDetect.detect(song.mix);
  float currentTime = millis();

  //get current time 
  if (keyPressed) {
    if (key == 't') {
      println(currentTime);
    }
  }
  
  if (beatDetect.isKick()) { 
    if (currentTime >= 37694.0) {
      shapes.add(new Circle(random(width), random(height), 0));
    }
    if (currentTime - lastBeatTime > measureDuration / beatsPerMeasure) {
      lastBeatTime = currentTime;
      float flowerX = random(width);
      float flowerY = random(height);
      shapes.add(new Flower(flowerX, flowerY, 0));
    }
  }
  
  // Update and draw all shapes
  for (int i = shapes.size() - 1; i >= 0; i--) {
    Shape shape = shapes.get(i);
    shape.update();
    shape.draw(maskImg);
    if (shape.getOpacity() <= 0) {
      shapes.remove(i); 
    }
  }

  maskImg.endDraw();
  
  // Apply the mask to the background image
  PImage maskedImage = backgroundImg.copy();
  maskedImage.mask(maskImg.get());
  background(52,44,44);
  image(maskedImage, 0, 0, width, height);
}

void stop() {
  song.close();
  minim.stop();
  super.stop();
}
