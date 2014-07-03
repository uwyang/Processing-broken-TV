boolean isFlashing = false;
int maxFlashTime = 7;
int flashTime = 0;



void addFlash() {
  loadPixels();
  float newBrightness=0;
  float newSaturation=0;
  if (isFlashing && flashTime>0) {
    for (int i=0; i<pixels.length; i++) {
      colorMode(HSB);
      color currPixel = pixels[i];
      float oldBrightness = 255-brightnessArr[i];
      newBrightness = 255-oldBrightness*(1- ((float)flashTime/(float)maxFlashTime));
      //newBrightness = brightnessArr[i];
      newSaturation = saturationArr[i]*(1- (float)flashTime/(float)maxFlashTime);
      //newSaturation = saturationArr[i];
      color newColor = color(hue(currPixel), newSaturation, newBrightness); 
      pixels[i] = newColor;
    }
    flashTime --;
    //println(brightness(pixels[100]));
    if (flashTime <=0) {
      isFlashing = false;
    }
  } 
  else {
    if (random(100) > 99) {
      isFlashing =true;
      flashTime = round(3*maxFlashTime/4);
    }
  }
  colorMode(RGB);
  updatePixels();
}

void roll(int rollNum) {
  loadPixels();
  int shiftAmount = width*rollNum;
  color[] firstLine = new color[shiftAmount];
  for (int i=0; i< shiftAmount; i++) {
    firstLine[i] = pixels[i];
  }
  for (int i=shiftAmount; i< pixels.length; i++) {
    pixels[i-shiftAmount] = pixels[i];
  }
  for (int i= pixels.length-shiftAmount; i< pixels.length; i++) {
    pixels[i] = firstLine[i - (pixels.length-shiftAmount)];
  }
  updatePixels();
}

void addStatic() {
  loadPixels();
  currh += dh;
  currh = currh % (height);
  for (int n=0; n< 7; n++) {
    for (int i=0; i< width; i++) {
      color randomColor = color(random(255));
      int h = (int)(currh + randomGaussian()*3) % (height);
      try {
        pixels[getPixelNum(i, h)] = randomColor;
      } 
      catch(Exception e) {
        println(h);
      }
    }
  }
  updatePixels();
}

