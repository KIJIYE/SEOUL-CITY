import processing.video.*;
Movie video;

int state = 0;

// water
int cols, rows; //col=height, row=width
int scl = 20; //scl = scale
int w = 1300; //water scale
int h = 900;
float flying = 0;
float [][] water;

// object rotation
float rotyBox;
float rotx = PI/4;
float roty = PI/4;

//dots
PVector[] points = new PVector[4];

// 3d objects
PShape house;
PImage housetex;

//alpha channel video
int numFrames = 600;
int currentFrame = 0;
PImage[] bubimages = new PImage[numFrames];

void setup(){
  size(800, 800, P3D); 
  
  // background ocean movie
  pushMatrix();
  video = new Movie (this, "ocean.mov");
  video.loop();
  popMatrix();

  
  // making water
  cols = w / scl;
  rows = h/ scl;
  water = new float[cols][rows];
  points[0] = new PVector(-90, -90, 0);
  points[1] = new PVector(90, -90, 0);
  points[2] = new PVector(90, 90, 0);
  points[3] = new PVector(-90, 90, 0);
  
  
  //import 3d object file & texture
  house = loadShape("house.obj"); 
  housetex = loadImage("CubeSurface_Color.jpg");
  house.setTexture(housetex);
  
}

  // background ocean movie
  void movieEvent(Movie video){
  video.read();
    
  //making bubble video
  pushMatrix();
  frameRate(30);
  for (int i = 0; i < numFrames; i++){
  String imageName = "bubble_" + nf(i, 4) + ".png";
  bubimages[i] = loadImage(imageName);
  }
  popMatrix();
}

void draw(){  
  background(96, 120, 145);
  
  //background ocean.mov
  pushMatrix();
  translate(-300, -300, -400);
  scale(2.5);
  image(video, 0, 0);
  popMatrix();
  
  //water
  pushMatrix();
  flying += 0.01;  
  float yoff = flying; //off= offset
  for (int y = 0; y < rows; y++){
    float xoff = 0;
    for (int x = 0; x < cols; x++){
      water[x][y] = map(noise(xoff, yoff), 0, 1, -100, 100);
      xoff += 0.1;
    }
    yoff += 0.1;
  }
  
  stroke(200);
  strokeWeight(0.3);
  translate(width/2, height/2);
  rotateX(PI/3);
  fill(#02AF97, 70);
  translate(-w/2, -h/2);
  for (int y = 0; y < rows-1; y++){
    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < cols; x++){
      vertex(x*scl, y*scl, water[x][y]);
      vertex(x*scl, (y+1)*scl, water[x][y+1]);
      //rect(x*scl, y*scl, scl, scl);
    }
    endShape();
  }
  popMatrix();
  
  // center white box
  pushMatrix();
  lights();
  fill(255);
  noStroke();
  translate(400, 400, 0);
  rotateX(rotx);
  rotateY(roty);
  rotateX(PI);
  rotateY(rotyBox);
  rotyBox += 0.008;
  box(65);
  popMatrix();
  
  // floating sphere 1
  pushMatrix();
  noStroke();
  fill(52, 0, 120, 80);
  lights();
  translate(300, 500, 200);
  sphere(30);
  popMatrix();
  
  // floating sphere 2
  pushMatrix();
  noStroke();
  fill(44, 77, 92);
  lights();
  translate(400, 530, 200);
  sphere(20);
  popMatrix();
  
  //center 4 points(dots)
  pushMatrix();
  translate(width/2, height/2);
  stroke(255);
  strokeWeight(16);
  noFill();
  for (PVector v : points){
    point(v.x, v.y);
  }
  popMatrix();
  
  //3d house1 object 
  pushMatrix();
  scale(0.5);
  lights();
  translate(width/2, 800, -200);
  rotateX(radians(170));
  rotateX(rotx);
  rotateY(roty);
  rotateY(rotyBox);
  rotyBox += 0.008;
  shape(house, 0, 0);
  popMatrix();
  
   //3d house2 object 
  pushMatrix();
  scale(0.5);
  lights();
  translate(1300, 1000, 200);
  rotateX(radians(170));
  rotateX(rotx);
  rotateY(roty);
  rotateY(rotyBox);
  rotyBox += 0.008;
  shape(house, 0, 0);
  popMatrix();
  
  //bubble video
  pushMatrix();
  currentFrame = (currentFrame +1 ) % numFrames;
  int offset = 0;
  for (int x = -100)
  popMatrix();
}

void mouseDragged() {
  float rate = 0.01;
  rotx += (pmouseY-mouseY) * rate;
  roty += (mouseX-pmouseX) * rate;
}

void mousePressed(){
  if(mouseX > 335 && mouseX < 465 && mouseY >335 && mouseY <465 && state == 0){
    textSize(32);
    fill(255);
    text("Hello World", 400, 350); 
    state = 0;
  }
}
