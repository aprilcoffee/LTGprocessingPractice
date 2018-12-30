
ArrayList<FireWork> fireworks;
void setup() {
  size(800, 800, P3D);
  blendMode(ADD);
  colorMode(HSB, 255);

  fireworks = new ArrayList<FireWork>();
}
void draw() {
  background(0);
  for (int s=0; s<fireworks.size(); s++) {
    fireworks.get(s).update();
    fireworks.get(s).show();
    if (fireworks.get(s).explode==true && fireworks.get(s).particles.isEmpty()==true) {
      fireworks.remove(s);
    }
  }
}
void keyReleased() {
  fireworks.add(new FireWork(random(100, width-100), height, color(random(255), 255, 255)));
}
class FireWork {
  ArrayList<Particle> particles;
  float x;
  float y;
  float vel;
  float acc;
  color col;
  boolean explode;
  FireWork(float _x, float _y, color _col) {  
    particles = new ArrayList<Particle>();
    x = _x;
    y = _y;
    col = _col;
    vel = -random(6, 8);
    acc = 0.05;
    explode = false;
  }
  void update() {
    if (explode==false) {
      y += vel;
      vel += acc;
    }
    if (vel>0 && explode != true) {
      explode = true;
      particles.add(new Particle(new PVector(x, y), col, 10, random(360)));
    }
  }
  void show() { 
    stroke(col);
    line(x, y, x, y+vel*5);
    for (int s=0; s<particles.size(); s++) {
      particles.get(s).update();
      particles.get(s).show();
      if (particles.get(s).radius < 3)particles.remove(s);
    }
  }

  class Particle {
    PVector pos;
    PVector ppos;
    color col;
    public float radius;
    float angle;
    Particle(PVector _pos, color _col, float _radius, float _angle) {
      pos = _pos.copy();
      col = _col;
      radius = _radius;
      angle = _angle;

      ppos = pos.copy();
    }
    void update() {
      pos.x += radius*cos(radians(angle));
      pos.y += radius*sin(radians(angle));

      radius*=0.975;
      if (random(10)>7.5) {
        particles.add(new Particle(
          pos, 
          color(hue(col)+random(-15, 15), 255, 255), 
          radius, 
          random(360)));
      }
    }
    void show() {
      stroke(col);
      line(pos.x, pos.y, ppos.x, ppos.y);
      ppos = pos.copy();
    }
  }
}
