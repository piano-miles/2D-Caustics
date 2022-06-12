int pixelCount = 640*480; //<>//
int rays = 0;
double[] R = new double[pixelCount];
double[] G = new double[pixelCount];
double[] B = new double[pixelCount];
float expo = 46.;

void initializeBuffer() {
  for (int i=0; i<pixelCount; i++) {
    R[i] = 0;
    G[i] = 0;
    B[i] = 0;
  }
}

void setup() {
  size(640, 480);
  colorMode(RGB, 1);
  smooth();
  background(0, 0, 0);
  initializeBuffer();
  loop();
}

float length(float x, float y) { //sq length
  return x*x+y*y;
}

float sdfq(int px, int py, int ax, int ay, int bx, int by) {
  int pax = px-ax;
  int pay = py-ay;
  int bax = bx-ax;
  int bay = by-ay;
  float h = constrain((float)(pax*bax+pay*bay)/(bax*bax+bay*bay), 0.0, 1.0);
  return length(pax - bax*h, pay - bay*h);
}

void addLine(int x1, int y1, int x2, int y2) {
  for (int i=0; i<width; i++) {
    for (int j=0; j<height; j++) {
      int pixelIndex = j*width+i;
      float d = sdfq(i, j, x1, y1, x2, y2);
      double r = 2/(d+1);
      double g = r*0.5;
      double b = g*0.5;

      if (r > 0) {
        R[pixelIndex] += r;
        G[pixelIndex] += g; //<>//
        B[pixelIndex] += b;
      }
    }
  }
  rays++;
}

void updateBuffer() {
  for (int i=0; i<pixelCount; i++) {
    float r = expo*(float)R[i]/rays;
    float g = expo*(float)G[i]/rays;
    float b = expo*(float)B[i]/rays;
    r = 1-1/(1+r*r);
    g = 1-1/(1+g*g);
    b = 1-1/(1+b*b);
    pixels[i] = color(r, g, b);
  }
}

void draw() {
  loadPixels();
  addLine(0, 0, mouseX, mouseY);
  updateBuffer();
  updatePixels();

  text(rays, 5, 10);
}
