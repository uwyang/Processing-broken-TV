float[] xshifts;
int maxShift = 200;
float shiftSeed = random(200);
boolean isShift=true;

void addWaveShift() {
  //copy: can be copied from it self or from another source
  //pimg.copy(sx, sy, sw, sh, dx, dy, dw, dh)
  //pimg.copy(src, sx, sy, sw, sh, dx, dy, dw, dh)
  image(a, 0, 0);
  if (!isShift) {
    if (random(1)>0.96) {
      float seed = random(100);
      for (int i=0; i<xshifts.length; i++) {
        xshifts[i] = noise(seed)-0.5;
        seed += 0.1;
      }
      isShift = true;
    }
  }
  else {

    shiftSeed += 1;
    for (int i=0; i< a.height; i++) {
      int newx = (int)(xshifts[i]*noise(shiftSeed)*maxShift);
      copyLine(a, i, newx);
    }
    if (random(1)> 0.95) {
      isShift = false;
      //println("shift now!");
    }
  }
}

void copyLine(PImage currimg, int rowNum, int shiftx) {
  PImage tmpImg;
  int tmpImgSize = width-shiftx;
  copy(a, 0, rowNum, width, 1, shiftx, rowNum, width, 1);
}


// other effects to make: slowing rolling screen
//see ju-on for reference. 
