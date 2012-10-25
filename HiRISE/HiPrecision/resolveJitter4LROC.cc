#include <algorithm>
#include <cmath>
#include <ctime>
#include <fstream>
#include <iostream>
#include <set>
#include <sstream>
#include <vector>
#include <Eigen/Dense>
#include <unsupported/Eigen/FFT>
#include "jitterUtils.h"

using namespace std;
using namespace Eigen;
using namespace jitter;

// RESOLVEJITTER4LROC is a modification of resolveJitter4HIJACK and takes
// in data from coreg files from LROC NAC images to estimate camera jitter. 
//
// Outputs are the jitter in the x (sample) and y (line) directions in
// pixels, realt (ephemeris time at that translation), and average
// error between the derived jitter function and the original data.

// Orignally written in Matlab by Aaron Boyd and Sarah Mattson for
// HiROC as part of the process to describe and correct geometric
// distortions caused by jitter in HiRISE images. Original version
// written approximately 6/2008. Rewritten in C++ by Oleg Alexandrov
// at NASA Ames in 6/2012.

int main(int argc, char ** argv){

  cout.precision(20);

  if (argc < 5){
    cerr << "\nUsage: " << argv[0] << " imageId rows lineOffset lineTime" << "\n\n";
    exit(1);
  }

  string imageId    =      argv[1];
  int    rows       = atoi(argv[2]);
  double lineOffset = atof(argv[3]);
  double lineTime   = atof(argv[4]);

  if (rows < 1){
    cerr << "ERROR: The parameter 'rows' must be positive." << endl;
    exit(1);
  }

  // Tolerance Coefficients
  //tolerance for the error
  double errorTol=.0000000001;
  int repetitions=50;
  
  //tolerance coefficient for the phase difference
  double tolcoef=.00001;
  
  // Gather data
  string flatfile = imageId + ".flat.tab";

  // get the data from the file
  int headerlines = 1;
  vector< vector<double> > data;
  getlines(flatfile, headerlines, data);
  if (data.size() <= 0){
    cerr << "ERROR: File " << flatfile << " has incorrect format." << endl;
    exit(1);
  }

  double dt   = lineOffset * lineTime;      // line separation * line time for the image
  int numRows = data.size();
  
  ArrayXd t(numRows, 1), offx(numRows, 1), offy(numRows, 1);
  for (int row = 0; row < numRows; row++){
    
    if ((int)data[row].size() < 6){
      cerr << "ERROR: File " << flatfile << " has incorrect format." << endl;
      exit(1);
    }

    t(row)    = data[row][3]*lineTime;
    offx(row) = data[row][4];
    offy(row) = data[row][5];
  }

  // Filter out the bad points.
  int windowSize = 6; 
  double windowWidth = 1.5;
  ArrayXd AveOffX(offx.rows(), offx.cols());
  medfilt1d(&offx(0), &AveOffX(0), offx.size(), windowSize);
  ArrayXd AveOffY(offy.rows(), offy.cols());
  medfilt1d(&offy(0), &AveOffY(0), offy.size(), windowSize);

  ArrayXd AdiffX = abs(offx - AveOffX);
  ArrayXd AdiffY = abs(offy - AveOffY);

  //BadX = find(AdiffX > windowWidth);
  //BadY = find(AdiffY > windowWidth);
  //BadXY = [BadX; BadY];
  //outOfRange = unique(BadXY);
  set<int> outOfRange;
  for (int s = 0; s < AdiffX.size(); s++) if (AdiffX(s) > windowWidth) outOfRange.insert(s);
  for (int s = 0; s < AdiffY.size(); s++) if (AdiffY(s) > windowWidth) outOfRange.insert(s);

  // Remove the bad points from the x and y offset data
  //x  = offx; x (outofRange) = [];
  //y  = offy; y (outofRange) = [];
  //tt = t;    tt(outofRange) = [];
 vector<double> xVec, yVec, ttVec;
 for (int s = 0; s < offx.size(); s++){
   if ( outOfRange.find(s) == outOfRange.end() ){
     xVec.push_back(offx(s));
     yVec.push_back(offy(s));
     ttVec.push_back(t(s));
   }
 }
 ArrayXd x, y, tt;
 if (!xVec.empty()){
   x  = Map<ArrayXd>(&xVec [0], xVec.size(),  1);
   y  = Map<ArrayXd>(&yVec [0], yVec.size(),  1);
   tt = Map<ArrayXd>(&ttVec[0], ttVec.size(), 1);
 }

 // Average multiple columns of offset data.
 numRows = x.size();
 ArrayXd ttt(numRows, 1), combinedX(numRows, 1), combinedY(numRows, 1);
 int a = 0, repeat = 1;
 ttt(a)       = tt(a);
 combinedX(a) = x(a);
 combinedY(a) = y(a);
 for (int n = 1; n < tt.size(); n++){
   if ( tt(n) == tt(n-1) ){
     repeat++;
     combinedX(a) = x(n)+combinedX(a);
     combinedY(a) = y(n)+combinedY(a);
     ttt(a)       = tt(n);
   }else{
     combinedX(a) = combinedX(a)/repeat;
     combinedY(a) = combinedY(a)/repeat;

     repeat = 1;
     a++;
     
     ttt(a)       = tt(n);
     combinedX(a) = x(n);
     combinedY(a) = y(n);
   }
 }
 combinedX(a)=combinedX(a)/repeat;
 combinedY(a)=combinedY(a)/repeat;
 numRows = a + 1;
 
 // A clumsy way of resizing an array
 MatrixXd tmpM;
 tmpM = ttt;       tmpM.conservativeResize(numRows, 1); t    = tmpM;
 tmpM = combinedX; tmpM.conservativeResize(numRows, 1); offx = tmpM;
 tmpM = combinedY; tmpM.conservativeResize(numRows, 1); offy = tmpM;

 int    nfft     = upperPowerOfTwo(rows);
 double t0       = t(0); // 1st sampled line
 double duration = t(t.size()-1) - t0;

 ArrayXd ET, ET_shift, ddt, xinterp, yinterp;
 ArrayXcd X, Y;
 MatrixXd overxx, overyy;
 bool isFirstTime = true;
 createMatrices(// Inputs
                isFirstTime, nfft, t0, duration, dt, t,  
                offx, offy,  
                // Outputs
                tt, ET, ET_shift, ddt,  
                xinterp, yinterp, X, Y,  
                overxx, overyy
                );

  // starting a loop to find correct phase tol
  int      k           = 0;
  double   minAvgError = numeric_limits<double>::max();
  int      minK        = 0;
  double   error       = errorTol;
  double   NaN = numeric_limits<double>::quiet_NaN();
  ArrayXd  minJitterX, minJitterY;
  MatrixXd overxxx, overyyy;
  while ( error >= errorTol && k < repetitions){
    
    k++;
    
    //setting the phase tolerance
    double phasetol = k*tolcoef;

    overxxx = overxx; overyyy = overyy;

    //null the frequencies that cause a problem
    set<int> nullindex;
    makeNullProblematicFrequencies(phasetol, ddt, nullindex, overxxx, overyyy);

    //overxxx(isnan(overxxx(:,1)),:)=0;
    makeNullIfNaNinFirstColumn(overxxx);
    //overyyy(isnan(overyyy(:,1)),:)=0;
    makeNullIfNaNinFirstColumn(overyyy);

    // take the sum of each row
    //overx(k,:)=sum(overxxx,1);
    //overy(k,:)=sum(overyyy,1);
    ArrayXd overx, overy;
    sumOverEachRow(overxxx, overx);
    sumOverEachRow(overyyy, overy);

    ArrayXd jitterx = overx - overx(0);
    ArrayXd jittery = overy - overy(0);

    // checking
    ArrayXd jittercheckx = uniform_interp(tt, jitterx, tt + dt/duration, NaN) - jitterx;
    ArrayXd jitterchecky = uniform_interp(tt, jittery, tt + dt/duration, NaN) - jittery;

    // eliminate NANs
    eliminateNaNs(jittercheckx);
    eliminateNaNs(jitterchecky);

    ArrayXd errorVec = 1.0/2.0*(abs(xinterp - (jittercheckx + X(0).real() / 2.0)) +
                                abs(yinterp - (jitterchecky + Y(0).real() / 2.0)));
    error = errorVec.mean();
    
    if (error < minAvgError){
      minAvgError = error;
      minK        = k;
      minJitterX  = jitterx;
      minJitterY  = jittery;
    }
    
  }

  ArrayXd Sample, Line;

  // starting a loop to find the correct filter size
  k           = 0;
  minK        = 0;
  error       = errorTol;
  minAvgError = numeric_limits<double>::max();
  
  while (error >= errorTol && k < repetitions){
    
    k++;

    double omega = k - 1;
    double c     = omega/(2.0*nfft);
    
    ArrayXd jitterxx, jitteryy;
    filterData(nfft, c, minJitterX, jitterxx);
    filterData(nfft, c, minJitterY, jitteryy);

    jitterxx = jitterxx - jitterxx(0);
    jitteryy = jitteryy - jitteryy(0);

    //checking
    ArrayXd jittercheckx = uniform_interp(tt, jitterxx, tt + dt/duration, NaN) - jitterxx;
    ArrayXd jitterchecky = uniform_interp(tt, jitteryy, tt + dt/duration, NaN) - jitteryy;
    
    // eliminate NANs
    eliminateNaNs(jittercheckx);
    eliminateNaNs(jitterchecky);

    ArrayXd errorVec = 1.0/2.0*(abs(xinterp - (jittercheckx + X(0).real() / 2.0)) +
                                abs(yinterp - (jitterchecky + Y(0).real() / 2.0)));
    error = errorVec.mean();
    std::cout << "error 2: " << error << std::endl;

    if (error < minAvgError){
      minK             = k;
      minAvgError      = error;
      Sample           = jitterxx;
      Line             = jitteryy;
    }
    
  }

  // Make a text file of the jitter data
  string jitterFileName = imageId + "_jitter_cpp.txt";
  std::cout << "Writing: " << jitterFileName << std::endl;
  FILE * fid = fopen (jitterFileName.c_str(), "w");  
  fprintf(fid,"# Using image %s the jitter was found with an\n", imageId.c_str());
  fprintf(fid,"# Average Error of %f\n", minAvgError);
  //fprintf(fid,"# Maximum Cross-track pixel smear %f\n", maxSmearSample);
  //fprintf(fid,"# Maximum Down-track pixel smear %f\n", maxSmearLine);
  //fprintf(fid,"# Maximum Pixel Smear Magnitude %f\n", maxSmearMag);
  fprintf(fid,"#\n# Sample_Offset          Line_Offset            Image_Time \n");
  for (int s = 0; s < Sample.size(); s++){
    fprintf(fid,"%12.16f     %12.16f     %12.9f\n", Sample(s), Line(s), ET(s));
  }
  fclose(fid);
  
  return 0;
}
