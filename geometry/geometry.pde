Grid[][] geometry;

int geometry_size = 120;
int geometry_radius = 200;

PImage earth;

void setup() {
  size(1000, 1000, P3D);
  //blendMode(ADD);
  hint(DISABLE_DEPTH_TEST);
  earth = loadImage("earth.jpeg");
  geometry = new Grid[geometry_size+1][geometry_size+1];
  for (int y=0; y<=geometry_size; y++) {
    for (int x=0; x<=geometry_size; x++) {
      float px = geometry_radius*cos(map(x, 0, geometry_size, -PI, PI))*cos(map(y, 0, geometry_size, -HALF_PI, HALF_PI));
      float py = geometry_radius*sin(map(x, 0, geometry_size, -PI, PI))*cos(map(y, 0, geometry_size, -HALF_PI, HALF_PI));
      float pz = geometry_radius*sin(map(y, 0, geometry_size, -HALF_PI, HALF_PI));
      geometry[x][y] = new Grid(x, y, px, py, pz);
    }
  }
}
void draw() {
  background(0);
  camera(180*sin(radians(frameCount)), 0, -1500, 0, 0, 0, 0, 1, 0);
  for (int y=0; y<geometry_size; y++) {
    for (int x=0; x<geometry_size; x++) {
      geometry[x][y].update();
      geometry[x][y].show();
    }
  }
}
void keyReleased() {
  for (int y=0; y<geometry_size; y++) {
    for (int x=0; x<geometry_size; x++) {
      geometry[x][y].explode();
    }
  }
}
class Grid {
  PVector pos;
  PVector posTarget;
  int num_x, num_y;
  float texture_x, texture_y;

  PVector[] neighbor;
  PVector[] neighborTarget;
  int explodeRadians = geometry_radius;
  float v;
  float a;

  Grid(int _num_x, int _num_y, float _px, float _py, float _pz) {
    num_x = _num_x;
    num_y = _num_y;

    v = 0;
    a = 0;

    pos = new PVector(_px, _py, _pz);

    neighbor = new PVector[3];

    float Right_x = geometry_radius*cos(map(num_x+1, 0, geometry_size, -PI, PI))*cos(map(num_y, 0, geometry_size, -HALF_PI, HALF_PI));
    float Right_y = geometry_radius*sin(map(num_x+1, 0, geometry_size, -PI, PI))*cos(map(num_y, 0, geometry_size, -HALF_PI, HALF_PI));
    float Right_z = geometry_radius*sin(map(num_y, 0, geometry_size, -HALF_PI, HALF_PI));

    float Down_x = geometry_radius*cos(map(num_x, 0, geometry_size, -PI, PI))*cos(map(num_y+1, 0, geometry_size, -HALF_PI, HALF_PI));
    float Down_y = geometry_radius*sin(map(num_x, 0, geometry_size, -PI, PI))*cos(map(num_y+1, 0, geometry_size, -HALF_PI, HALF_PI));
    float Down_z = geometry_radius*sin(map(num_y+1, 0, geometry_size, -HALF_PI, HALF_PI));

    float RightDown_x = geometry_radius*cos(map(num_x+1, 0, geometry_size, -PI, PI))*cos(map(num_y+1, 0, geometry_size, -HALF_PI, HALF_PI));
    float RightDown_y = geometry_radius*sin(map(num_x+1, 0, geometry_size, -PI, PI))*cos(map(num_y+1, 0, geometry_size, -HALF_PI, HALF_PI));
    float RightDown_z = geometry_radius*sin(map(num_y+1, 0, geometry_size, -HALF_PI, HALF_PI));

    neighbor[0] = new PVector(Right_x, Right_y, Right_z); //Right
    neighbor[1] = new PVector(Down_x, Down_y, Down_z); //Down
    neighbor[2] = new PVector(RightDown_x, RightDown_y, RightDown_z); //Right Down

    texture_x = map(num_x, 0, geometry_size, 0, 1);
    texture_y = map(num_y, 0, geometry_size, 0, 1);

    neighborTarget = new PVector[3];
    posTarget = new PVector();
    for (int s=0; s<3; s++) {
      neighborTarget[s] =neighbor[s].copy();
    }
    pos = posTarget.copy();
  }
  void explode() {
    float r = random(geometry_radius, geometry_radius+300);

    float px = r*cos(map(num_x, 0, geometry_size, -PI, PI))*cos(map(num_y, 0, geometry_size, -HALF_PI, HALF_PI));
    float py = r*sin(map(num_x, 0, geometry_size, -PI, PI))*cos(map(num_y, 0, geometry_size, -HALF_PI, HALF_PI));
    float pz = r*sin(map(num_y, 0, geometry_size, -HALF_PI, HALF_PI));

    float Right_x = r*cos(map(num_x+1, 0, geometry_size, -PI, PI))*cos(map(num_y, 0, geometry_size, -HALF_PI, HALF_PI));
    float Right_y = r*sin(map(num_x+1, 0, geometry_size, -PI, PI))*cos(map(num_y, 0, geometry_size, -HALF_PI, HALF_PI));
    float Right_z = r*sin(map(num_y, 0, geometry_size, -HALF_PI, HALF_PI));

    float Down_x = r*cos(map(num_x, 0, geometry_size, -PI, PI))*cos(map(num_y+1, 0, geometry_size, -HALF_PI, HALF_PI));
    float Down_y = r*sin(map(num_x, 0, geometry_size, -PI, PI))*cos(map(num_y+1, 0, geometry_size, -HALF_PI, HALF_PI));
    float Down_z = r*sin(map(num_y+1, 0, geometry_size, -HALF_PI, HALF_PI));

    float RightDown_x = r*cos(map(num_x+1, 0, geometry_size, -PI, PI))*cos(map(num_y+1, 0, geometry_size, -HALF_PI, HALF_PI));
    float RightDown_y = r*sin(map(num_x+1, 0, geometry_size, -PI, PI))*cos(map(num_y+1, 0, geometry_size, -HALF_PI, HALF_PI));
    float RightDown_z = r*sin(map(num_y+1, 0, geometry_size, -HALF_PI, HALF_PI));

    posTarget = new PVector(px, py, pz);
    neighborTarget[0] = new PVector(Right_x, Right_y, Right_z); //Right
    neighborTarget[1] = new PVector(Down_x, Down_y, Down_z); //Down
    neighborTarget[2] = new PVector(RightDown_x, RightDown_y, RightDown_z); //Right Down
  }
  void update() {
    float easing = 0.05;
    for (int s=0; s<3; s++) {
      neighbor[s].add(PVector.sub(neighborTarget[s], neighbor[s]).mult(easing));
    }
    pos.add(PVector.sub(posTarget, pos).mult(easing));
  }
  void show() {
    noFill();
    noStroke();
    //stroke(255);
    beginShape(TRIANGLE_STRIP);
    textureMode(NORMAL);
    texture(earth);
    vertex(pos.x, pos.y, pos.z, texture_x, texture_y);

    vertex( neighbor[0].x, neighbor[0].y, neighbor[0].z, 
      geometry[num_x+1][num_y].texture_x, geometry[num_x+1][num_y].texture_y);

    vertex( neighbor[1].x, neighbor[1].y, neighbor[1].z, 
      geometry[num_x][num_y+1].texture_x, geometry[num_x][num_y+1].texture_y);

    vertex(neighbor[2].x, neighbor[2].y, neighbor[2].z, 
      geometry[num_x+1][num_y+1].texture_x, geometry[num_x+1][num_y+1].texture_y);

    endShape(CLOSE);
  }
}
