#include "vonoroi.sl"
// Erik Sandrén, erila135
// 2015-11-16

surface bacon_surface() {

  //Highlights
  normal Nf = faceforward (N, I);
  vector V = -normalize (I);
  color specularC = 1; //Specular color
  float specularK = 0.4;

  //Bacon colors
  color darkBacon = (0.4, 0.1, 0.1);
  color bacon = (0.50, 0.15, 0.08);
  color fat = (0.83, 0.78, 0.52);
  
  //three different parts for bacon meat
  float darkVal = 0.6*cos(t*PI*7) + 
                  0.2*noise(4*s,6*t) +
                  0.1*noise(9*s, 5*t) +
                  0.1*noise(50*s);  

  float fatVal = 0.5*cos(t*PI*2+PI/4) +
                 0.4*noise(7*s);
 
  //Make distinct edges between fat and meat
  float darkStep = filterstep(0.02, darkVal);
  float fatStep = filterstep(0.6, fatVal);

  //Mix colors
  color baconPart = mix(fat, darkBacon, darkStep);
  baconPart = mix(baconPart, bacon, fatStep);
  
  //add diffuse and specular to result
  Ci = baconPart*diffuse(Nf) + specularK* specularC * specular(Nf, V, .08);
}
