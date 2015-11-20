#include "vonoroi.sl"

// Erik Sandrén, erila135
// 2015-11-16

displacement bacon_displacement() {
  
  //make edges of the bacon uneven
  float edgeNoise = 0.025*cos(s*PI*9) + 
                    0.5*(noise(2*s, 4*t)-.5) +
                    0.2*(noise(10*s,2*t)-.5) +
                    0.15*(noise(20*s,3*t)-.5) +
                    0.05*(noise(60*s,3*t)-.5);
  //Make shorter edges also a bit uneven with cos function
  P = P + .25*point(0.02*cos(t*PI*6), edgeNoise, 0); 
 
  // Vonoroi used to create cell like structure in displacement of surface
  float cellFrequency = 50;
  float f1, f2, x1, y1, x2, y2; // Output parameters for voronoi()
  voronoi_f2_2d(s, t, cellFrequency, 0.7, f1, f2, x1, y1, x2, y2);
  float cell = filterstep(0.1, f2-f1);
  P = P + 0.001*point(0,0,cell);
  
  N = calculatenormal(P); 
}
