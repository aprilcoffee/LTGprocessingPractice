PImage img;
ShowImage showImage;
ArrayList<ShowImage> imgs;
void setup() {
  size(1000, 1000, P3D);
  // blendMode(ADD);
  hint(DISABLE_DEPTH_TEST);
  img = loadImage("Telescope.jpg");
  imgs = new ArrayList<ShowImage>();
  for (int s=0; s<1; s++) {
    imgs.add(new ShowImage(125, 125, 0, 0, 1, 750, new PVector(0, 0), new PVector(0, 0), 0));
    //x y t_x,t_y,t_l,length v a layer
  }
}
void draw() {
  background(0);
  for (int s=0; s<imgs.size(); s++) {
    ((ShowImage)(imgs.get(s))).update();
    if (random(100)>99) {
      if (((ShowImage)(imgs.get(s))).layer<5) {
        ((ShowImage)(imgs.get(s))).crack();
        imgs.remove(s);
      }
    }
    ((ShowImage)(imgs.get(s))).show();
  }
}
class ShowImage {
  float px, py;
  float img_Length;
  float textureX, textureY;
  float texture_Length;
  int layer;
  PVector v;
  PVector a;
  ShowImage(float _x, float _y, float _textureX, float _textureY, float _texture_Length, float _img_Length, PVector _v, PVector _a, int _layer) {
    px = _x;
    py = _y;
    a = _a.copy();
    v = _v.copy();
    v = new PVector(0,0);
    img_Length = _img_Length;
    textureX = _textureX;
    textureY = _textureY;
    texture_Length = _texture_Length;
    layer=_layer;
    if (layer==1) {
      a.add(random(-0.003, 0.003), random(-0.003, 0.003));
    }
  }
  void update() {
    if (layer!=0) {
      px += v.x;
      py += v.y;
      v.add(a);
    }
  }
  void show() {
    //stroke(255);
    //noFill();
    //fill(255);
    //noStroke();
    beginShape();
    texture(img);
    textureMode(NORMAL);
    vertex(px, py, textureX, textureY);
    vertex(px+img_Length, py, textureX+texture_Length, textureY);
    vertex(px+img_Length, py+img_Length, textureX+texture_Length, textureY+texture_Length);
    vertex(px, py+img_Length, textureX, textureY+texture_Length);
    endShape();
  }
  void crack() {
    //leftUp
    imgs.add(new ShowImage(px, py, 
      textureX, textureY, texture_Length/2, 
      img_Length/2, v, a.mult(random(1, 1.5)), layer+1));
    //rightUp
    imgs.add(new ShowImage(px+img_Length/2, py, 
      textureX+texture_Length/2, textureY, texture_Length/2, 
      img_Length/2, v, a.mult(random(1, 1.5)), layer+1));

    //leftDown
    imgs.add(new ShowImage(px+img_Length/2, py+img_Length/2, 
      textureX+texture_Length/2, textureY+texture_Length/2, texture_Length/2, 
      img_Length/2, v, a.mult(random(1, 1.5)), layer+1));

    //rightDown
    imgs.add(new ShowImage(px, py+img_Length/2, 
      textureX, textureY+texture_Length/2, texture_Length/2, 
      img_Length/2, v, a.mult(random(1, 1.5)), layer+1));
  }
}
