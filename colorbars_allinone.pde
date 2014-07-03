// @pjs preload must be used to preload the image so that it will be available when used in the sketch  

/* @pjs preload="./ColorBars.gif"; */
PImage a;
int dh= 1;
int currh;
float k2 = 0.00003;
//float k3 = -0.0000002;
float k3 =0; //3rd order, only affects outer pixels. do not use.
float[] brightnessArr; 
float[] saturationArr;
int currEffect=0;
int numEffects = 4;

void setup()
{
  frameRate(30);
  a = loadImage("./ColorBars.gif");
  size(a.width, a.height);
  currh = round(height/2);
  image(a, 0, 0);
  loadPixels();

  //for flash effect
  brightnessArr = new float[pixels.length];
  saturationArr = new float[pixels.length];
  for (int i=0; i< pixels.length; i++) {
    brightnessArr[i] = brightness(pixels[i]);
    saturationArr[i] = saturation(pixels[i]);
  }

  //for waveshift effect
  maxShift = round(width*1.5);

  int h = height;
  float seed = random(100);
  xshifts = new float[height];
  for (int i=0; i<xshifts.length; i++) {
    xshifts[i] = noise(seed)-0.5;
    seed += 0.1;
  }
  
  //set up all the effects
  currEffect = 3;
}



void draw()
{
  image(a, 0, 0);
  doEffect(currEffect);
  if (random(100)> 99.9) {
    currEffect = floor(random(numEffects));
  }
  addBarrel();
  smooth();
}

void addBarrel() {

  loadPixels();
  float cx = width/2;
  float cy = height/2;

  color[] pixelCopy= new color[pixels.length];
  arrayCopy( pixels, pixelCopy);
  resetColor(color(255));
  float resizeW = (width/2)/getR(width/2);
  float resizeH = (height/2)/getR(height/2);
  for (int i=0; i< width; i++) {
    for (int j=0; j< height; j++) {
      float dx = (i - cx);
      float dy = (j - cy);
      float r = sqrt(dx*dx + dy*dy);
      float angle = atan2(dy, dx);
      float newr = getR(r)*max(resizeH, resizeW);
      int newx = round((cos(angle)*newr + cx));
      int newy = round((sin(angle)*newr + cy));
      try {
        if ( inFrame(newx, newy) ) {
          int currNum = getPixelNum(i, j);
          int origNum = getPixelNum(newx, newy); 
          pixels[currNum] = pixelCopy[origNum];
        }
      }
      catch(Exception e) {
        println(i + " " + j);
      }
    }
  }
  updatePixels();
}



int getPixelNum(int w, int h) {
  if (h<0) {
    h+= height;
  }
  return h*width + w;
}

boolean inFrame(int x, int y) {
  if (x>=0 && y>=0 && x<width && y<height) {
    return true;
  }
  return false;
}

void resetColor(color c) {
  for (int i=0; i<pixels.length; i++) {
    pixels[i] = c;
  }
}

float getR(float r) {
  return r*(1 + k2*r*r + k3*r*r*r);
}

void doEffect(int n) {
  switch (n) {
  case 0:
    int rollNum = round((frameCount) % height);
    roll(rollNum);
    break; 
  case 1:
    addStatic(); 
    break;
  case 2:
    addFlash();
    break;
  case 3:
    addWaveShift();
    break;
  }
}

void mouseClicked(){
  currEffect = (currEffect + 1)% numEffects;
}
