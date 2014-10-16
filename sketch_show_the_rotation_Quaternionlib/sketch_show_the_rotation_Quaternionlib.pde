import processing.serial.*;

Serial myPort;  // Create object from Serial class
String val;     // Data received from the serial port
//float reading_q;  // data received as int


float x,y,z;    // for display
int i = 1; 
int i_s;
float angle_now;
float axi_x;
float axi_y;
float axi_z;

float length_now = 264;
float width_now = 121.6;
float hight_now = 16;
Chip my_chip;   // my chip!
Quaternion q_now;  //Quaternion for q.



void setup() {
  
  frameRate(100);
  size(800,450,P3D);
  x = 400;
  y = 225;  
  z = 0;
  
  q_now = new Quaternion(1,0,0,0);
  
 
  
  // Open whatever port is the one you're using. 
  String portName = "/dev/tty.usbmodem1411";
  myPort = new Serial(this, portName, 38400); 
  //myPort.bufferUntil('\n');
  delay(100);
  myPort.clear();  

}

void draw() {

  //q_now.W = -0.11; q_now.X = -0.95; q_now.Y = -0.29 ; q_now.Z = -0.05;
  //q_now = new Quaternion(cos(angle_now/2),sin(angle_now/2) * axi_x,sin(angle_now/2) * axi_y,sin(angle_now/2) * axi_z);
  //q_now = new Quaternion(1,0,0,0);
  
  val = readArduino(q_now, i_s);
  q_now.normalize(); //normalize the quaternion
  
  my_chip = new Chip(q_now,length_now,width_now,hight_now); // initiallize my_chip
  
   background(255); // important for clean the background
   //spotLight(255, 255, 255, width/2, height/2, 400, 0, 0, -1, PI/4, 2); // light the world!
   
  // print the axis
   int x_axis_long = 100;
   int y_axis_long = 75;
   int z_axis_long = 50;
   int x_pos = 300;
   int y_pos = 150;
   int z_pos = 0;
   // x axis
   line(0+x-x_pos,0+y+y_pos,0,x_axis_long+x-x_pos,0+y+y_pos,0);
   stroke(0);
   line(x_axis_long+x-x_pos,0+y+y_pos,0,x_axis_long-10+x-x_pos,-5+y+y_pos,0);
   line(x_axis_long+x-x_pos,0+y+y_pos,0,x_axis_long-10+x-x_pos,5+y+y_pos,0);
   // z axis
   line(0+x-x_pos,0+y+y_pos,0,0+x-x_pos,-y_axis_long+y+y_pos,0);
   line(0+x-x_pos,-y_axis_long+y+y_pos,0,5+x-x_pos,-y_axis_long+10+y+y_pos,0);
   line(0+x-x_pos,-y_axis_long+y+y_pos,0,-5+x-x_pos,-y_axis_long+10+y+y_pos,0);
   // y axis
   line(0+x-x_pos,0+y+y_pos,0,0+x-x_pos,0+y+y_pos,z_axis_long);
   
   translate(x,y,z);
   
   my_chip.vertices_cal();  
   //my_chip.draw_chip_new();
   my_chip.draw_chip();
   my_chip.printlocation();
  
  println(frameRate);
  i++;

  System.gc();
}

// create a chip class with vertices after rotation according to
// quaternion.
class Chip {
  
  Quaternion q; // variables to hold quaternion.
  float length_x;
  float width_y;
  float hight_z;
  PImage top_side = loadImage("top-view-pinout.jpg");
  PImage bottom_side = loadImage("back-side.jpg");
  PImage facing_side = loadImage("facing_side.jpg");
  Quaternion Apos;
  
  Quaternion Bpos;
 
    Quaternion Cpos;

    Quaternion Dpos;

    Quaternion Epos;

    Quaternion Fpos;

    Quaternion Gpos;

    Quaternion Hpos;
  

  
  // constructor for Chip.
  Chip(Quaternion q_temp, float length_x_temp, float width_y_temp, float hight_z_temp) {
    q = q_temp;
    length_x = length_x_temp;
    width_y = width_y_temp;
    hight_z = hight_z_temp;
    
    Apos = new Quaternion(0,-length_x_temp/2,-width_y_temp/2,-hight_z_temp/2);
  
    Bpos = new Quaternion(0,length_x_temp/2,-width_y_temp/2,-hight_z_temp/2);
 
    Cpos = new Quaternion(0,-length_x_temp/2,width_y_temp/2,-hight_z_temp/2);

    Dpos = new Quaternion(0,-length_x_temp/2,-width_y_temp/2,hight_z_temp/2);

    Epos = new Quaternion(0,length_x_temp/2,width_y_temp/2,-hight_z_temp/2);

    Fpos = new Quaternion(0,length_x_temp/2,width_y_temp/2,hight_z/2);

    Gpos = new Quaternion(0,length_x_temp/2,-width_y_temp/2,hight_z_temp/2);

    Hpos = new Quaternion(0,-length_x_temp/2,width_y_temp/2,hight_z_temp/2);

    // ready the 8 vertices of the chip.
  }
  
  
  void vertices_cal() {
    //calculate the vertices of chip and draw the chip.
    Quaternion Apos_intial = new Quaternion(0,-length_x/2,-width_y/2,-hight_z/2);
    Apos = q.mult(Apos_intial).mult(q.conjugate()); 
    Quaternion Bpos_intial = new Quaternion(0,length_x/2,-width_y/2,-hight_z/2);
    Bpos = q.mult(Bpos_intial).mult(q.conjugate());
    Quaternion Cpos_intial = new Quaternion(0,-length_x/2,width_y/2,-hight_z/2);
    Cpos = q.mult(Cpos_intial).mult(q.conjugate());
    Quaternion Dpos_intial = new Quaternion(0,-length_x/2,-width_y/2,hight_z/2);
    Dpos = q.mult(Dpos_intial).mult(q.conjugate());
    Quaternion Epos_intial = new Quaternion(0,length_x/2,width_y/2,-hight_z/2);
    Epos = q.mult(Epos_intial).mult(q.conjugate());
    Quaternion Fpos_intial = new Quaternion(0,length_x/2,width_y/2,hight_z/2);
    Fpos = q.mult(Fpos_intial).mult(q.conjugate());
    Quaternion Gpos_intial = new Quaternion(0,length_x/2,-width_y/2,hight_z/2);
    Gpos = q.mult(Gpos_intial).mult(q.conjugate());
    Quaternion Hpos_intial = new Quaternion(0,-length_x/2,width_y/2,hight_z/2);
    Hpos = q.mult(Hpos_intial).mult(q.conjugate());
  }
    
  void draw_chip() {    
    //start to draw!
    
    //bottom_side
    beginShape();
    texture(bottom_side);
    vertex(-Apos.X, Apos.Y, Apos.Z, 0, 0);
    vertex(-Bpos.X, Bpos.Y, Bpos.Z, 544, 0);
    vertex(-Epos.X, Epos.Y, Epos.Z, 544, 268);
    vertex(-Cpos.X, Cpos.Y, Cpos.Z, 0, 268);
    endShape(CLOSE);
    
    //top_side
    beginShape();
    texture(top_side);
    vertex(-Dpos.X, Dpos.Y, Dpos.Z, 544, 0);
    vertex(-Gpos.X, Gpos.Y, Gpos.Z, 0,0);
    vertex(-Fpos.X, Fpos.Y, Fpos.Z, 0, 264);
    vertex(-Hpos.X, Hpos.Y, Hpos.Z, 554, 264);
    endShape(CLOSE);
    
    //facing_side
    beginShape();
    
    texture(facing_side);
    vertex(-Hpos.X, Hpos.Y, Hpos.Z, 0, 0);
    vertex(-Cpos.X, Cpos.Y, Cpos.Z, 0, 10);
    vertex(-Epos.X, Epos.Y, Epos.Z, 165, 10);
    vertex(-Fpos.X, Fpos.Y, Fpos.Z, 165, 0);
    endShape(CLOSE);
    
    //back_side
    beginShape();
    
    texture(facing_side);
    vertex(-Apos.X, Apos.Y, Apos.Z, 0, 0);
    vertex(-Dpos.X, Dpos.Y, Dpos.Z, 0, 10);
    vertex(-Gpos.X, Gpos.Y, Gpos.Z, 165, 10);
    vertex(-Bpos.X, Bpos.Y, Bpos.Z, 165, 0);
    endShape(CLOSE);
    
    //left_side
    beginShape();
    
    //texture(side_side);
    vertex(-Hpos.X, Hpos.Y, Hpos.Z, 0, 0);
    vertex(-Cpos.X, Cpos.Y, Cpos.Z, 0, 10);
    vertex(-Apos.X, Apos.Y, Apos.Z, 165, 10);
    vertex(-Dpos.X, Dpos.Y, Dpos.Z, 165, 0);
    endShape(CLOSE);
    
    //right_side
    beginShape();
    
    //texture(right_side);
    vertex(-Bpos.X, Bpos.Y, Bpos.Z, 0, 0);
    vertex(-Gpos.X, Gpos.Y, Gpos.Z, 0, 10);
    vertex(-Fpos.X, Fpos.Y, Fpos.Z, 165, 10);
    vertex(-Epos.X, Epos.Y, Epos.Z, 165, 0);
    endShape(CLOSE);
    
    
    
    }
    
    // a new idea of draw a chip
  void draw_chip_new () {
    // rotate parameters
    float roll_angle_partone = 2 * (q.W * q.X + q.Y * q.Z);
    float roll_angle_parttwo = 1 - 2 * (q.X * q.X + q.Y * q.Y);
    float yaw_angle_partone = 2 * (q.W * q.Z + q.X * q.Y);
    float yaw_angle_parttwo = 1 - 2 * (q.Y * q.Y + q.Z * q.Z);
    
    //start to draw!
    //start to rotate the canvas
    pushMatrix();
    //rotate X Y Z (Roll, Pitch, Yaw) calculated from quaternion
    //reference http://en.wikipedia.org/wiki/Conversion_between_quaternions_and_Euler_angles

    rotateX(-atan2(roll_angle_partone, roll_angle_parttwo));
    rotateY(asin(2 * (q.W * q.Y - q.Z * q.X)));
    rotateZ(atan2(yaw_angle_partone, yaw_angle_parttwo));
    
    //bottom_side
    beginShape();
    texture(bottom_side);
    vertex(Apos.X, Apos.Y, Apos.Z, 0, 0);
    vertex(Bpos.X, Bpos.Y, Bpos.Z, 544, 0);
    vertex(Epos.X, Epos.Y, Epos.Z, 544, 268);
    vertex(Cpos.X, Cpos.Y, Cpos.Z, 0, 268);
    endShape(CLOSE);
    
    //top_side
    beginShape();
    texture(top_side);
    vertex(Dpos.X, Dpos.Y, Dpos.Z, 0, 0);
    vertex(Gpos.X, Gpos.Y, Gpos.Z, 554, 0);
    vertex(Fpos.X, Fpos.Y, Fpos.Z, 554, 264);
    vertex(Hpos.X, Hpos.Y, Hpos.Z, 0, 264);
    endShape(CLOSE);
    
    //facing_side
    beginShape();
    
    texture(facing_side);
    vertex(Hpos.X, Hpos.Y, Hpos.Z, 0, 0);
    vertex(Cpos.X, Cpos.Y, Cpos.Z, 0, 10);
    vertex(Epos.X, Epos.Y, Epos.Z, 165, 10);
    vertex(Fpos.X, Fpos.Y, Fpos.Z, 165, 0);
    endShape(CLOSE);
    
    //back_side
    beginShape();
    
    texture(facing_side);
    vertex(Apos.X, Apos.Y, Apos.Z, 0, 0);
    vertex(Dpos.X, Dpos.Y, Dpos.Z, 0, 10);
    vertex(Gpos.X, Gpos.Y, Gpos.Z, 165, 10);
    vertex(Bpos.X, Bpos.Y, Bpos.Z, 165, 0);
    endShape(CLOSE);
    
    //left_side
    beginShape();
    
    //texture(side_side);
    vertex(Hpos.X, Hpos.Y, Hpos.Z, 0, 0);
    vertex(Cpos.X, Cpos.Y, Cpos.Z, 0, 10);
    vertex(Apos.X, Apos.Y, Apos.Z, 165, 10);
    vertex(Dpos.X, Dpos.Y, Dpos.Z, 165, 0);
    endShape(CLOSE);
    
    //right_side
    beginShape();
    
    //texture(right_side);
    vertex(Bpos.X, Bpos.Y, Bpos.Z, 0, 0);
    vertex(Gpos.X, Gpos.Y, Gpos.Z, 0, 10);
    vertex(Fpos.X, Fpos.Y, Fpos.Z, 165, 10);
    vertex(Epos.X, Epos.Y, Epos.Z, 165, 0);
    endShape(CLOSE);
    
    // reset the canvas
    popMatrix();
  }
    
    // print the location of ABCDEFGH
  void printlocation () {
    println("Apos: ");print(Apos.X); print(Apos.Y); println(Apos.Z);
    println("Bpos: ");print(Bpos.X); print(Bpos.Y); println(Bpos.Z);
    println("LWH: "+length_x+" "+width_y+" "+hight_z+" "+"q: "+q.W+" "+q.X+" "+q.Y+" "+q.Z);
    println(val);
  }

}

String readArduino(Quaternion q_read, int i_read) {
  String inputString = null;
  if(myPort.available() > 0) {
    inputString = myPort.readStringUntil('\n');
  if (inputString !=null && inputString.length() > 0) {
    String [] inputStringArr = split(inputString, ",");
    
    q_read.W = float(inputStringArr[0]);
    q_read.X = float(inputStringArr[1]);
    q_read.Y = float(inputStringArr[2]);
    q_read.Z = float(inputStringArr[3]);
    i_read = int(inputStringArr[4]);
    
    
  }
  }
return inputString;
}

void drawLine(float x1, float y1, float z1, float x2, float y2, float z2, float weight, color strokeColour)
{
  PVector p1 = new PVector(x1, y1, z1);
  PVector p2 = new PVector(x2, y2, z2);
  PVector v1 = new PVector(x2-x1, y2-y1, z2-z1);
  float rho = sqrt(pow(v1.x,2)+pow(v1.y,2)+pow(v1.z,2));
  float phi = acos(v1.z/rho);
  float the = atan2(v1.y,v1.x);
  v1.mult(0.5);
  
  pushMatrix();
  translate(x1,y1,z1);
  translate(v1.x, v1.y, v1.z);
  rotateZ(the);
  rotateY(phi);
  noStroke();
  fill(strokeColour);
  box(weight,weight,p1.dist(p2)*1.2);
  popMatrix();
}
  

/***************************************************************************
 * Quaternion class written by BlackAxe / Kolor aka Laurent Schmalen in 1997
 * Translated to Java(with Processing) by RangerMauve in 2012
 * this class is freeware. you are fully allowed to use this class in non-
 * commercial products. Use in commercial environment is strictly prohibited
 */

 class Quaternion {
    float W, X, Y, Z;      // components of a quaternion

  // default constructor
   Quaternion() {
    W = 1.0;
    X = 0.0;
    Y = 0.0;
    Z = 0.0;
  }

  // initialized constructor

   Quaternion(float w, float x, float y, float z) {
    W = w;
    X = x;
    Y = y;
    Z = z;
  }

  // quaternion multiplication
   Quaternion mult (Quaternion q) {
    Quaternion q_mult = new Quaternion(0,0,0,0);
    float w = W*q.W - (X*q.X + Y*q.Y + Z*q.Z);

    float x = W*q.X + q.W*X + Y*q.Z - Z*q.Y;
    float y = W*q.Y + q.W*Y + Z*q.X - X*q.Z;
    float z = W*q.Z + q.W*Z + X*q.Y - Y*q.X;

    q_mult.W = w;
    q_mult.X = x;
    q_mult.Y = y;
    q_mult.Z = z;
    return q_mult;
  }

  // conjugates the quaternion
   Quaternion conjugate () {
    Quaternion q_con = new Quaternion(0,0,0,0);
    q_con.W = W;
    q_con.X = -X;
    q_con.Y = -Y;
    q_con.Z = -Z;
    
    return q_con;
  }

  // inverts the quaternion
   Quaternion reciprical () {
    float norme = sqrt(W*W + X*X + Y*Y + Z*Z);
    if (norme == 0.0)
      norme = 1.0;

    float recip = 1.0 / norme;

    W =  W * recip;
    X = -X * recip;
    Y = -Y * recip;
    Z = -Z * recip;

    return this;
  }

  // sets to unit quaternion
   Quaternion normalize() {
    float norme = sqrt(W*W + X*X + Y*Y + Z*Z);
    if (norme == 0.0)
    {
      W = 1.0; 
      X = Y = Z = 0.0;
    }
    else
    {
      float recip = 1.0/norme;

      W *= recip;
      X *= recip;
      Y *= recip;
      Z *= recip;
    }
    return this;
  }

  // Makes quaternion from axis
   Quaternion fromAxis(float Angle, float x, float y, float z) { 
    float omega, s, c;
    int i;

    s = sqrt(x*x + y*y + z*z);

    if (abs(s) > Float.MIN_VALUE)
    {
      c = 1.0/s;

      x *= c;
      y *= c;
      z *= c;

      omega = -0.5f * Angle;
      s = (float)sin(omega);

      X = s*x;
      Y = s*y;
      Z = s*z;
      W = (float)cos(omega);
    }
    else
    {
      X = Y = 0.0f;
      Z = 0.0f;
      W = 1.0f;
    }
    normalize();
    return this;
  }

   Quaternion fromAxis(float Angle, PVector axis) {
    return this.fromAxis(Angle, axis.x, axis.y, axis.z);
  }

  // Rotates towards other quaternion
   void slerp(Quaternion a, Quaternion b, float t)
  {
    float omega, cosom, sinom, sclp, sclq;
    int i;


    cosom = a.X*b.X + a.Y*b.Y + a.Z*b.Z + a.W*b.W;


    if ((1.0f+cosom) > Float.MIN_VALUE)
    {
      if ((1.0f-cosom) > Float.MIN_VALUE)
      {
        omega = acos(cosom);
        sinom = sin(omega);
        sclp = sin((1.0f-t)*omega) / sinom;
        sclq = sin(t*omega) / sinom;
      }
      else
      {
        sclp = 1.0f - t;
        sclq = t;
      }

      X = sclp*a.X + sclq*b.X;
      Y = sclp*a.Y + sclq*b.Y;
      Z = sclp*a.Z + sclq*b.Z;
      W = sclp*a.W + sclq*b.W;
    }
    else
    {
      X =-a.Y;
      Y = a.X;
      Z =-a.W;
      W = a.Z;

      sclp = sin((1.0f-t) * PI * 0.5);
      sclq = sin(t * PI * 0.5);

      X = sclp*a.X + sclq*b.X;
      Y = sclp*a.Y + sclq*b.Y;
      Z = sclp*a.Z + sclq*b.Z;
    }
  }

   Quaternion exp()
  {                               
    float Mul;
    float Length = sqrt(X*X + Y*Y + Z*Z);

    if (Length > 1.0e-4)
      Mul = sin(Length)/Length;
    else
      Mul = 1.0;

    W = cos(Length);

    X *= Mul;
    Y *= Mul;
    Z *= Mul; 

    return this;
  }

   Quaternion log()
  {
    float Length;

    Length = sqrt(X*X + Y*Y + Z*Z);
    Length = atan(Length/W);

    W = 0.0;

    X *= Length;
    Y *= Length;
    Z *= Length;

    return this;
  }
}






