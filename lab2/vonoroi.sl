/************************************************************
 * file: voronoi.sl
 * author: Peter Stuart
 * date: 11/16/2002
 *
 * Bug fixes and 3D extension by Stefan Gustavson 2005-11-08
 * Bug fixes for Aqsis and 1D version by Stefan Gustavson 2007-11-12
 * Slight updates by Stefan Gustavson 2015-11-12
 *
 * Description: 1D, 2D and 3D "cellular noise", borrowing heavily
 * from ideas presented by Stephen Worley, in a version similar
 * to the "voronoi" functions used in the book "Advanced RenderMan".
 *
 ************************************************************/

/* 1D cellular noise, of limited use but included for completeness */
void voronoi_f1_1d (float s, freq; float jitter;
            output float f1;
            output float posf)
{
  float p = s*freq;
  float thiscell = floor(s*freq)+0.5;
  
  f1 = freq+1;
  uniform float i;
  for (i=-1; i<=1; i+=1) {
    float testcell = thiscell + i;
    float pos = testcell + jitter*(cellnoise(testcell) - 0.5);
    float offset = abs(pos - p);

    if (offset < f1) {
      f1 = offset;
      posf = pos;
    }
  }
  posf /= freq;
}


/* 2D cellular noise, closest feature point only */
void voronoi_f1_2d (float s, t, freq; float jitter;
            output float f1;
            output float pos_s, pos_t)
{
  point Plocal = point(s*freq, t*freq, 0); /* transform s and t */

  point thiscell = point(floor(s*freq)+0.5, floor(t*freq)+0.5, 0);

  f1 = freq+1;
  float i, j;
  for (i=-1; i<=1; i+=1) {
    for (j=-1; j<=1; j+=1) {
      point testcell = thiscell + vector(i,j,0);
      point pos = testcell + jitter*(vector cellnoise(testcell) - 0.5);
      vector offset = pos - Plocal;
      float dist = offset.offset;
      if (dist < f1) {
    f1 = dist;
    pos_s = xcomp(pos);
    pos_t = ycomp(pos);
      }
    }
  }

  /* transform back to s and t system */
  pos_s /= freq;
  pos_t /= freq;

  f1 = sqrt(f1);
}


/* 2D cellular noise, two closest feature points */
void voronoi_f2_2d (float s, t, freq; float jitter;
            output float f1, f2;
            output float pos_s, pos_t;
            output float pos2_s, pos2_t)
{
  point Plocal = point(s*freq, t*freq, 0); /* transform s and t */

  point thiscell = point(floor(s*freq)+0.5, floor(t*freq)+0.5, 0);

  f1 = freq+1;

  f2 = 0;
  pos_s = 0; pos_t = 0;

  uniform float i, j;
  for (i=-1; i<=1; i+=1) {
    for (j=-1; j<=1; j+=1) {
      point testcell = thiscell + vector(i,j,0);
      point pos = testcell + jitter*(vector cellnoise(testcell) - 0.5);
      vector offset = pos - Plocal;
      float dist = offset.offset;

      if (dist < f1) {
    f2 = f1;
    pos2_s = pos_s;
    pos2_t = pos_t;
    f1 = dist;
    pos_s = xcomp(pos);
    pos_t = ycomp(pos);
      }
      else if (dist < f2) { // BUG FIX - Stefan G
    f2 = dist;
    pos2_s = xcomp(pos);
    pos2_t = ycomp(pos);
      }
    }
  }

  /* transform back to s and t system */
  pos_s /= freq;
  pos_t /= freq;
  pos2_s /= freq;
  pos2_t /= freq;

  f1 = sqrt(f1);
  f2 = sqrt(f2);
}

/* 3D cellular noise, closest feature point only */
void voronoi_f1_3d (point Plocal; float freq; float jitter;
            output float f1; output point pos)
{
  point Ptex = Plocal * freq; /* scale xyz texture domain */
  point thiscell = point(floor(xcomp(Ptex))+0.5,
                         floor(ycomp(Ptex))+0.5,
                         floor(zcomp(Ptex))+0.5);

  f1 = freq+1; // Large value to start with
  uniform float i, j, k;
  for (i=-1; i<=1; i+=1) {
    for (j=-1; j<=1; j+=1) {
      for (k=-1; k<=1; k+=1) {
        point testcell = thiscell + vector(i,j,k);
        point testpos = testcell + jitter*(vector cellnoise(testcell) - 0.5);
        vector offset = testpos - Ptex;
        float dist = offset.offset;
        if (dist < f1) {
          f1 = dist;
          pos = testpos;
        }
      }
    }
  }

  /* transform back to xyz system */
  pos /= freq;

  f1 = sqrt(f1);
}


/* For some reason, this function does not work in Aqsis 1.2.
 * Use the version above with output parameters instead.
 * This function is OK in PRMan, though.
 */
float voronoi_f1_3d(point Plocal; float freq; float jitter)
{
  float f1;
  point pos;
  voronoi_f1_3d(Plocal, freq, jitter, f1, pos);
  return f1;
}


/* 3D cellular noise, two closest feature points */
void voronoi_f2_3d (point Plocal; float freq; float jitter;
            output float f1, f2; output point pos1, pos2)
{
  point Ptex = Plocal * freq; /* scale xyz texture domain */
  point thiscell = point(floor(xcomp(Ptex))+0.5,
                         floor(ycomp(Ptex))+0.5,
                         floor(zcomp(Ptex))+0.5);

  f1 = freq+1; // Large value to start with
  f2 = freq+1;
  uniform float i, j, k;
  for (i=-1; i<=1; i+=1) {
    for (j=-1; j<=1; j+=1) {
      for (k=-1; k<=1; k+=1) {
        point testcell = thiscell + vector(i,j,k);
        point testpos = testcell + jitter*(vector cellnoise(testcell) - 0.5);
        vector offset = testpos - Ptex;
        float dist = offset.offset;
        if (dist < f1) {
          f2 = f1;
      f1 = dist;
          pos2 = pos1;
          pos1 = testpos;
        }
        else if (dist < f2) {
          f2 = dist;
          pos2 = testpos;
        }
      }
    }
  }

  /* transform back to xyz system */
  pos1 /= freq;
  pos2 /= freq;

  f1 = sqrt(f1);
  f2 = sqrt(f2);
}


/* These functions don't work in some versions of Aqsis.
 * Use the versions above with output parameters instead.
 * Having a "point" return value is OK in PRMan, though.
 */
point voronoi_f2_2d(float x, y; float freq; float jitter)
{
  float f1, f2;
  float x1, y1, x2, y2;
  voronoi_f2_2d(x, y, freq, jitter, f1, f2, x1, y1, x2, y2);
  return point(f1, f2, f2-f1);
}

point voronoi_f2_3d(point Plocal; float freq; float jitter)
{
  float f1, f2;
  point pos1, pos2;
  voronoi_f2_3d(Plocal, freq, jitter, f1, f2, pos1, pos2);
  return point(f1, f2, f2-f1);
}
