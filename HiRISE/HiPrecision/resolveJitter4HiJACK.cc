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
#include "gnuplotScript.h"

// Sarah proposed several bug fixes but they change the results too
// much. For now Sarah suggested we keep them disabled.
#define APPLY_BUG_FIXES (0)


using namespace std;
using namespace Eigen;
using namespace jitter;

// Perform the jitter derivation for a HiRISE observation.
//
// Outputs are the jitter in the x (sample) and y (line) directions in
// pixels, realt (ephemeris time at that translation), average error
// between the derived jitter function and the original data, linerate
// (line time read from flat files), and TDI. These outputs are
// written to a text file. Another output is the pixel smear, also
// written to a file.

// Orignally written in Matlab by Aaron Boyd and Sarah Mattson for
// HiROC as part of the process to describe and correct geometric
// distortions caused by jitter in HiRISE images. Original version
// written approximately 6/2008. Rewritten in C++ by Oleg Alexandrov
// at NASA Ames in 6/2012.

void parseFileGetData(// Inputs
                      string filePath, int which, int repetitions,
                      double lineInterval, int windowSize, double windowWidth,
                      // Outputs
                      int & TDI, int & nfft,
                      double & linerate, double & t0, double & duration,
                      ArrayXd & tt, ArrayXd & ET, ArrayXd & ET_shift,
                      double & dt, ArrayXd & ddt,
                      ArrayXd & t, ArrayXd & offx, ArrayXd & offy,
                      ArrayXd & xinterp, ArrayXd & yinterp,
                      ArrayXcd & X, ArrayXcd & Y, MatrixXd & overxx, MatrixXd & overyy
                      ){
  
  // Parse the current text file, then extract and process the data into a
  // matrix.

  std::cout << "Reading: " << filePath << std::endl;
  
  // The very first time this code is called we will initialize the
  // quantities TDI, nfft, linerate, t0, duration, tt, ET, and
  // ET_shift which we will use in subsequent calls.
  bool isFirstTime = (ET.rows() == 0);
  
  string line;
  int headerlines;
  ifstream handle (filePath.c_str());
  if (!handle){
    std::cerr << "ERROR: Cannot open file: " << filePath << std::endl;
    exit(1);
  }
  
  int imageLength;
  double tmp;
  headerlines = 6;
  line        = getline(filePath, handle, headerlines);
  sscanf(line.c_str(), "%*s %*s %lf", &tmp);
  imageLength = (int)tmp;
  
  headerlines = 6;
  line        = getline(filePath, handle, headerlines);
  sscanf(line.c_str(), "%*s %*s %lf", &tmp);
  if (isFirstTime){
    TDI = (int)tmp;    
  }
  
  headerlines = 1;
  line        = getline(filePath, handle, headerlines);
  sscanf(line.c_str(), "%*s %*s %lf", &tmp);
  if (isFirstTime){
    linerate = tmp;    
  }

  handle.close();

  // For improved speed use powers of 2 in Fourier transform.
  // Dividing by the line interval used in hijitreg.
  if (isFirstTime) nfft = upperPowerOfTwo(imageLength/lineInterval);

  // Read the remaining values in a matrix (vector of vectors)
  headerlines = 55;
  vector< vector<double> > data;
  getlines(filePath, headerlines, data);
  if (data.size() <= 0){
    cerr << "ERROR: File " << filePath << " has incorrect format." << endl;
    exit(1);
  }

  // put the data into usable variables
  int column;
  if (which == 1) column = 3; else column = 0;

  if (data[0].size() < 4){
    cerr << "ERROR: File " << filePath << " has incorrect format." << endl;
    exit(1);
  }
  dt = which*(data[0][0] - data[0][3]);

  int numRows = data.size();
  t    = ArrayXd(numRows, 1);
  offx = ArrayXd(numRows, 1);
  offy = ArrayXd(numRows, 1);
  
  for (int row = 0; row < numRows; row++){

    if ((int)data[row].size() < max(column, 7) + 1){
      cerr << "ERROR: File " << filePath << " has incorrect format." << endl;
      exit(1);
    }
    
    t(row)    = data[row][column];
    offx(row) = which*(data[row][6] - data[row][1]);
    offy(row) = which*(data[row][7] - data[row][2]);
  }

  if (isFirstTime){
    t0       = t(0);
    duration = t(numRows-1) - t0;
  }

  // filtering out the bad points
  // magnitude=(offx.^2+offy.^2).^(1/2);
  ArrayXd magnitude = sqrt(offx*offx + offy*offy);
  // avemag = medfilt1(magnitude,windowSize);
  ArrayXd avemag(numRows, 1);
  medfilt1d(&magnitude(0), &avemag(0), numRows, windowSize);

  // Put the indices out of range in a set
  set<int> outOfRange;
  for (int row = 0; row < numRows; row++){
    if (magnitude(row) - windowWidth - avemag(row) > 0 ||
        magnitude(row) + windowWidth - avemag(row) < 0
        ){
      outOfRange.insert(row);
    }
  }
  
  //for the color images with multiple lines in each.
  ArrayXd ttt(numRows, 1), x(numRows, 1), y(numRows, 1);
  int a = 0;
  ttt(a) = t(0);
  x(a)   = offx(a);
  y(a)   = offy(a);
  int repeat = 1;

  int start = 1;
#if APPLY_BUG_FIXES
#else
  static int ppp = 0; ppp++;
  if (ppp == 3) start = 2;
#endif

  // Remove the bad points from the data.
  // Average multiple columns of offset data.
  for (int n = start; n < numRows; n++){
    //testing = isempty(find(outofRange==n,1));
    bool testing = ( outOfRange.find(n) == outOfRange.end() );
    if (testing){
      if ( t(n) == t(n-1)){ 
        repeat = repeat+1;
        x(a)   = offx(n)+x(a);
        y(a)   = offy(n)+y(a);
        ttt(a) = t(n);
      }else{
        x(a)   = x(a)/repeat;
        y(a)   = y(a)/repeat;
        repeat = 1;
        a      = a+1;
        ttt(a) = t(n);
        x(a)   = offx(n);
        y(a)   = offy(n);
      }
    }
  }

  x(a) = x(a)/repeat;
  y(a) = y(a)/repeat;
  t=ttt;

  numRows = a + 1;

  // A clumsy way of resizing an array
  MatrixXd tmpM;
  tmpM = x; tmpM.conservativeResize(numRows, 1); x = tmpM;
  tmpM = y; tmpM.conservativeResize(numRows, 1); y = tmpM;
  tmpM = t; tmpM.conservativeResize(numRows, 1); t = tmpM;

  // Smoothing the offsets to reduce noise.
  // The outputs are offx and offy.
  double c = 2.0/nfft;
  filterData(nfft, c, x, offx);
  filterData(nfft, c, y, offy);

  createMatrices(// Inputs
                 isFirstTime, nfft, t0, duration, dt, t, offx, offy,  
                 // Outputs
                 tt, ET, ET_shift, ddt,  
                 xinterp, yinterp, X, Y, overxx, overyy
                 );

  return;
}

bool isNotNull(MatrixXd const& mat, set<int> & nullindex){

  if (mat.cols() < 5){
    // For some reason the original Matlab code uses this magic number 5.
    cerr << "WARNING: Found a matrix with fewer than 5 columns." << endl;
  }

#if APPLY_BUG_FIXES
  // Implementation of:
  //~isequal(zeros(zerosize1,5),mat(nullindex1,1:5))
  // Return 'true' unless mat(nullindex, 1:5) is the zero matrix
#else
  // Implementation of:
  // ~isequal(zeros(1,5),mat(nullindex,1:5))
  // Return 'true' unless mat(nullindex, 1:5) is the zero matrix with 1 row and 5 columns
  if (nullindex.size() != 1) return true;
  if (mat.cols()        < 5) return true;
#endif
  
  for (int col = 0; col < min((int)mat.cols(), 5); col++){
    for (set<int>::iterator it = nullindex.begin(); it != nullindex.end(); it++){
      if (mat(*it, col) != 0) return true;
    }
  }

  return false;
}

void overwriteNullFrequencies(// Inputs
                              set<int> & nullindex1, 
                              MatrixXd const& overxxx2, MatrixXd const& overxxx3,
                              // Outputs
                              MatrixXd & overxxx1
                              ){

  //overxxx1(nullindex1,:)=(overxxx2(nullindex1,:)+overxxx3(nullindex1,:))/(~isequal(zeros(zerosize1,5),overxxx2(nullindex1,1:5))+~isequal(zeros(zerosize1,5),overxxx3(nullindex1,1:5)));
  double den1x = isNotNull(overxxx2, nullindex1) + isNotNull(overxxx3, nullindex1);
  for (int col = 0; col < overxxx1.cols(); col++){
    for (set<int>::iterator it = nullindex1.begin(); it != nullindex1.end(); it++){
      overxxx1(*it, col) = (overxxx2(*it, col) + overxxx3(*it, col))/den1x;
    }
  }
  return;
}

void pixelSmear(// Inputs
                ArrayXd const& Sample, ArrayXd const& Line, ArrayXd const& T,
                double linerate, int TDI, string imageLocation, string imageId,
                // Outputs
                double & maxSmearS, double & maxSmearL, double & maxSmearMag 
                ){

  // pixelSmear finds max smeared pixel amount in the image from derived
  // jitter function.
  //
  // Sample is the sample offsets from the jitter function
  // Line is the line offsets from the jitter function
  // T is the ephemeris time from the jitter function
  // linerate is read from the flat file, equivalent to TDI
  //
  // Pixel smear due to jitter is calculated by interpolating the jitter
  // function at intervals equivalent to the linerate.  Then the
  // difference is taken over that interval and multiplied by the TDI.
  // This provides an estimated minimum for pixel smear. If the motion
  // that caused the smear is not captured in the jitter derivation,
  // then it cannot be plotted here.

  //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // Original Matlab code written by Sarah Mattson for HiROC as part of the 
  // process to describe and correct geometric distortions caused by jitter
  // in HiRISE images. Original version written 9/3/2008.
  //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  // The array T has large values. Use a shifted version of it when
  // interpolating to reduce the effect of those values on numerical
  // accuracy.
  ArrayXd shiftedT = T - T(0);
  
  //xi = T(1):linerate:T(end);
  int n = (int)floor((shiftedT(shiftedT.size() - 1) - shiftedT(0))/linerate) + 1;
  ArrayXd xi  = ArrayXd::LinSpaced(n, 0, n-1)*linerate + shiftedT(0);
  
  // Interpolate the jitter function at intervals equivalent to the linerate
  ArrayXd yis = pchip(shiftedT, Sample, xi, 0);
  ArrayXd yil = pchip(shiftedT, Line,   xi, 0);

  // Undo the earlier shift
  xi += T(0);
  
  // Calculate the rate of change with respect to the linerate
  // in the sample direction
  ArrayXd dysdx = ArrayXd::Zero(n, 1);
  for (int k = 0; k < n-1; k++) dysdx(k) = (yis(k+1) - yis(k))*TDI;
  // in the line direction
  ArrayXd dyldx = ArrayXd::Zero(n, 1);
  for (int k = 0; k < n-1; k++) dyldx(k) = (yil(k+1) - yil(k))*TDI;

  // Calculate the magnitude of the smear
  ArrayXd magSmear = sqrt(dysdx*dysdx + dyldx*dyldx);
  
  // Find maxSmearS, the largest element by magnitude in dysdx
  maxSmearS = 0.0;
  for (int s = 0; s < dysdx.size(); s++){
    if (abs(dysdx(s)) > abs(maxSmearS) ) maxSmearS = dysdx(s);
  }

  // Find maxSmearL, the largest element by magnitude in dyldx
  maxSmearL = 0.0;
  for (int s = 0; s < dyldx.size(); s++){
    if (abs(dyldx(s)) > abs(maxSmearL) ) maxSmearL = dyldx(s);
  }

  // Find maxSmearMag, the largest element by magnitude in magSmear
  maxSmearMag = 0.0;
  for (int s = 0; s < magSmear.size(); s++){
    if (abs(magSmear(s)) > abs(maxSmearMag) ) maxSmearMag = magSmear(s);
  }

  // Make a text file of the smear data
  string fileName = imageLocation + imageId + "_smear_cpp.txt";
  std::cout << "Writing: " << fileName << std::endl;
  FILE * fid = fopen (fileName.c_str(), "w");  
  fprintf(fid,"# Smear values are calculated from the derived jitter function for %s.\n",imageId.c_str());
  fprintf(fid,"# Maximum Cross-track pixel smear %f\n", maxSmearS);
  fprintf(fid,"# Maximum Down-track pixel smear %f\n", maxSmearL);
  fprintf(fid,"# Maximum Pixel Smear Magnitude %f\n", maxSmearMag);
  fprintf(fid,"\n# Sample                 Line                   EphemerisTime \n");
  for (int s = 0; s < dysdx.size(); s++){
    fprintf(fid, "%12.16f     %12.16f     %12.9f\n", dysdx(s), dyldx(s), xi(s));
  }
  fclose(fid);
  
}

void writeDataForPlotting(string dataFileName, int numData, ArrayXd** Data, string* Labels){

  // Given a collection of arrays of data, print those arrays as
  // columns in a text file. The columns need not have the same
  // number of elements.
  
  std::cout << "Writing: " << dataFileName << std::endl;

  FILE * fid = fopen (dataFileName.c_str(), "w");

  // Print the labels for each column
  for (int s = 0; s < numData; s++) fprintf(fid, "%25s ", Labels[s].c_str());
  fprintf(fid, "\n");

  int maxLen = 0;
  for (int s = 0; s < numData; s++){
    maxLen = max(maxLen, (int)Data[s]->size());
  }

  // Print the data columns
  double NaN = numeric_limits<double>::quiet_NaN();
  for (int row = 0; row < maxLen; row++){
    for (int col = 0; col < numData; col++){
      if ( row < Data[col]->size() )
        fprintf(fid, "%25.16f ", (*Data[col])(row));
      else
        fprintf(fid, "%25.16f ", NaN);
    }
    fprintf(fid, "\n");
  }
  
}


void writeGnuplotFile(string gnuplotFileName, string dataFileName, string imgFileName,
                      string filePath1, string filePath2, string filePath3){

  std::cout << "Writing: " << gnuplotFileName << std::endl;

  ofstream fid(gnuplotFileName.c_str());
  fid << createGnuplotScript(dataFileName, imgFileName, filePath1, filePath2, filePath3);
  fid.close();
  
}

int main(int argc, char ** argv){

  cout.precision(20);

  // In the flat files, if RED4 is the 'From', use -1 for which1. If RED4 is the 'Match', use 1.
  
  if (argc < 10){
    cerr << "\nUsage: " << argv[0] << " imageLocation imageId lineInterval filePath1 which1 filePath2 which2 filePath3 which3" << "\n\n";
    exit(1);
  }

  string imageLocation = argv[1];

  // Append the trailing slash if not present
  int l = imageLocation.size();
  if ( l == 0){
    cerr << "ERROR: The image location was not specified." << endl;
    exit(1);
  }
  if (imageLocation[l-1] != '/'){
    imageLocation += "/";
  }
  
  string imageId      = argv[2];
  double lineInterval = atof(argv[3]);
  string filePath1    = imageLocation + argv[4];
  int    which1       = atoi(argv[5]);
  string filePath2    = imageLocation + argv[6];
  int    which2       = atoi(argv[7]);
  string filePath3    = imageLocation + argv[8];
  int    which3       = atoi(argv[9]);

  if (abs(which1) != 1 || abs(which2) != 1 || abs(which3) != 1 ){
    cerr << "ERROR: The values for the parameters 'which1', 'which2', and 'which3' must be 1 or -1." << endl;
    exit(1);
  }

  if (lineInterval < 1){
    cerr << "ERROR: The parameter 'lineInterval' must be positive." << endl;
    exit(1);
  }
  
  double NaN = numeric_limits<double>::quiet_NaN();

  // Tolerance for the error
  double errorTol = 0.0000000001;
  int repetitions = 50;
  
  // Tolerance coefficient for the phase difference
  double tolcoef=.01;
  
  int windowSize     = 11;
  double windowWidth = 2;

  int TDI, nfft; double linerate, t0, duration; // these params will be initialized just once
  ArrayXd tt, ET, ET_shift;                     // these params will be initialized just once
  double dt1, dt2, dt3;
  ArrayXd ddt1, ddt2, ddt3, t1, t2, t3, offx1, offx2, offx3, offy1, offy2, offy3;
  ArrayXd xinterp1, yinterp1, xinterp2, yinterp2, xinterp3, yinterp3;
  ArrayXcd X1, Y1, X2, Y2, X3, Y3;
  MatrixXd overxx1, overyy1, overxx2, overyy2, overxx3, overyy3;

  // Read the three data files
  parseFileGetData(// Inputs
                   filePath1, which1, repetitions, lineInterval, windowSize, windowWidth, 
                   // Outputs
                   TDI, nfft, linerate, t0, duration, tt, ET, ET_shift, dt1, ddt1,
                   t1, offx1, offy1, xinterp1, yinterp1, X1, Y1, overxx1, overyy1
                   );
  parseFileGetData(// Inputs
                   filePath2, which2, repetitions, lineInterval, windowSize, windowWidth, 
                   // Outputs
                   TDI, nfft, linerate, t0, duration, tt, ET, ET_shift, dt2, ddt2,
                   t2, offx2, offy2, xinterp2, yinterp2, X2, Y2, overxx2, overyy2
                   );
  parseFileGetData(// Inputs
                   filePath3, which3, repetitions, lineInterval, windowSize, windowWidth, 
                   // Outputs
                   TDI, nfft, linerate, t0, duration, tt, ET, ET_shift, dt3, ddt3,
                   t3, offx3, offy3, xinterp3, yinterp3, X3, Y3, overxx3, overyy3
                   );

  // starting a loop to find correct phase tol
  int      k           = 0;
  double   minAvgError = numeric_limits<double>::max();
  int      minK        = 0;
  double   error       = errorTol;
  ArrayXd  minJitterX, minJitterY;
  MatrixXd overxxx1, overyyy1, overxxx2, overyyy2, overxxx3, overyyy3;

    while ( error >= errorTol && k < repetitions){

    k++;
    
    //setting the phase tolerance
    double phasetol = k*tolcoef;

    overxxx1 = overxx1; overyyy1 = overyy1;
    overxxx2 = overxx2; overyyy2 = overyy2;
    overxxx3 = overxx3; overyyy3 = overyy3;

    //null the frequencies that cause a problem
    set<int> nullindex1, nullindex2, nullindex3;
    makeNullProblematicFrequencies(phasetol, ddt1, nullindex1, overxxx1, overyyy1);
    makeNullProblematicFrequencies(phasetol, ddt2, nullindex2, overxxx2, overyyy2);
    makeNullProblematicFrequencies(phasetol, ddt3, nullindex3, overxxx3, overyyy3);

    // Overwrite null frequencies. The last argument is the output.
    overwriteNullFrequencies(nullindex1, overxxx2, overxxx3, overxxx1);
#if APPLY_BUG_FIXES
    overwriteNullFrequencies(nullindex2, overxxx1, overxxx3, overxxx2);
#else
    //overxxx2(nullindex2,:)=(overxxx2(nullindex2,:)+overxxx3(nullindex2,:))/(~isequal(zeros(1,5),overxxx1(nullindex2,1:5))+~isequal(zeros(1:5),overxxx3(nullindex2,1:5)));
    double den2x = isNotNull(overxxx1, nullindex2) + isNotNull(overxxx3, nullindex2);
    for (int col = 0; col < overxxx2.cols(); col++){
      for (set<int>::iterator it = nullindex2.begin(); it != nullindex2.end(); it++){
        overxxx2(*it, col) = (overxxx2(*it, col) + overxxx3(*it, col))/den2x;
      }
    }
#endif
    overwriteNullFrequencies(nullindex3, overxxx2, overxxx1, overxxx3);
    overwriteNullFrequencies(nullindex1, overyyy2, overyyy3, overyyy1);
#if APPLY_BUG_FIXES
    overwriteNullFrequencies(nullindex2, overyyy1, overyyy3, overyyy2);
#else
    //overyyy2(nullindex2,:)=(overyyy2(nullindex2,:)+overyyy3(nullindex2,:))/(~isequal(zeros(1,5),overyyy1(nullindex2,1:5))+~isequal(zeros(1:5),overyyy3(nullindex2,1:5)));
    double den2y = isNotNull(overyyy1, nullindex2) + isNotNull(overyyy3, nullindex2);
    for (int col = 0; col < overyyy2.cols(); col++){
      for (set<int>::iterator it = nullindex2.begin(); it != nullindex2.end(); it++){
        overyyy2(*it, col) = (overyyy2(*it, col) + overyyy3(*it, col))/den2y;
      }
    }    
#endif
    overwriteNullFrequencies(nullindex3, overyyy2, overyyy1, overyyy3);

    // Adding all frequencies together
    //overxxx=(overxxx1+overxxx2+overxxx3)/3;
    //overyyy=(overyyy1+overyyy2+overyyy3)/3;
    overxxx1 += overxxx2 + overxxx3; overxxx1 /= 3.0;
    overyyy1 += overyyy2 + overyyy3; overyyy1 /= 3.0;
    MatrixXd & overxxx = overxxx1;
    MatrixXd & overyyy = overyyy1;

#if APPLY_BUG_FIXES
    // Set all NaN and Inf to zero.
    //overxxx(isnan(overxxx))=0;
    //overxxx(isinf(overxxx))=0;
    for (int col = 0; col < overxxx.cols(); col++){
      for (int row = 0; row < overxxx.rows(); row++){
        if ( isNaN(overxxx(row, col)) || isInf(overxxx(row, col)) ) overxxx(row, col) = 0;
      }
    }
    //overyyy(isnan(overyyy))=0;
    //overyyy(isinf(overyyy))=0;
    for (int col = 0; col < overyyy.cols(); col++){
      for (int row = 0; row < overyyy.rows(); row++){
        if ( isNaN(overyyy(row, col)) || isInf(overyyy(row, col)) ) overyyy(row, col) = 0;
      }
    }
#else
    //overxxx(isnan(overxxx(:,1)),:)=0;
    makeNullIfNaNinFirstColumn(overxxx);
    //overyyy(isnan(overyyy(:,1)),:)=0;
    makeNullIfNaNinFirstColumn(overyyy);
#endif
    
    // take the sum of each row
    //overx(k,:)=sum(overxxx,1);
    //overy(k,:)=sum(overyyy,1);
    ArrayXd overx, overy;
    sumOverEachRow(overxxx, overx);
    sumOverEachRow(overyyy, overy);
    
    ArrayXd jitterx = overx - overx(0);
    ArrayXd jittery = overy - overy(0);
    
    //checking
    
    ArrayXd jittercheckx1 = uniform_interp(tt, jitterx, tt + dt1/duration, NaN) - jitterx;
    ArrayXd jitterchecky1 = uniform_interp(tt, jittery, tt + dt1/duration, NaN) - jittery;

    ArrayXd jittercheckx2 = uniform_interp(tt, jitterx, tt + dt2/duration, NaN) - jitterx;
    ArrayXd jitterchecky2 = uniform_interp(tt, jittery, tt + dt2/duration, NaN) - jittery;

    ArrayXd jittercheckx3 = uniform_interp(tt, jitterx, tt + dt3/duration, NaN) - jitterx;
    ArrayXd jitterchecky3 = uniform_interp(tt, jittery, tt + dt3/duration, NaN) - jittery;

    eliminateNaNs(jittercheckx1); eliminateNaNs(jitterchecky1);
    eliminateNaNs(jittercheckx2); eliminateNaNs(jitterchecky2);
    eliminateNaNs(jittercheckx3); eliminateNaNs(jitterchecky3);

#if APPLY_BUG_FIXES
    ArrayXd errorVec = 1.0/6.0*(abs(xinterp1 - (jittercheckx1 + X1(0).real()/2.0)) +
                                abs(xinterp2 - (jittercheckx2 + X2(0).real()/2.0)) +
                                abs(xinterp3 - (jittercheckx3 + X3(0).real()/2.0)) +
                                abs(yinterp1 - (jitterchecky1 + Y1(0).real()/2.0)) +
                                abs(yinterp2 - (jitterchecky2 + Y2(0).real()/2.0)) +
                                abs(yinterp3 - (jitterchecky3 + Y3(0).real()/2.0)));
#else
    ArrayXd errorVec = 1.0/6.0*(abs(xinterp1 - (jittercheckx1 + X1(0).real() / 2)) +
                                abs(xinterp2 - (jittercheckx2 + X2(0).real()))     +
                                abs(xinterp3 - (jittercheckx3 + X3(0).real()))     +
                                abs(yinterp1 - (jitterchecky1 + Y1(0).real() / 2)) +
                                abs(yinterp2 - (jitterchecky2 + Y2(0).real() / 2)) +
                                abs(yinterp3 - (jitterchecky3 + Y3(0).real() / 2)));
#endif
    
    error = errorVec.mean();
    cout << "error 1: " << error << endl;
    
    if (error < minAvgError){
      minAvgError = error;
      minK        = k;
      minJitterX  = jitterx;
      minJitterY  = jittery;
    }

  }

  k           = 0;
  minK        = 0;
  error       = errorTol;
  minAvgError = numeric_limits<double>::max();

  // The jitter in the x (sample) and y (line) directions in pixels.
  // This is the jitter with minimum error, after scanning through all
  // frequencies omega.
  ArrayXd Sample, Line;
  ArrayXd  minJitterCheckX1, minJitterCheckX2, minJitterCheckX3;
  ArrayXd  minJitterCheckY1, minJitterCheckY2, minJitterCheckY3;
  
  //starting a loop to find the correct filter size
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
    
    ArrayXd jittercheckx1 = uniform_interp(tt, jitterxx, tt + dt1/duration, NaN) - jitterxx;
    ArrayXd jitterchecky1 = uniform_interp(tt, jitteryy, tt + dt1/duration, NaN) - jitteryy;

    ArrayXd jittercheckx2 = uniform_interp(tt, jitterxx, tt + dt2/duration, NaN) - jitterxx;
    ArrayXd jitterchecky2 = uniform_interp(tt, jitteryy, tt + dt2/duration, NaN) - jitteryy;

    ArrayXd jittercheckx3 = uniform_interp(tt, jitterxx, tt + dt3/duration, NaN) - jitterxx;
    ArrayXd jitterchecky3 = uniform_interp(tt, jitteryy, tt + dt3/duration, NaN) - jitteryy;

    eliminateNaNs(jittercheckx1); eliminateNaNs(jitterchecky1);
    eliminateNaNs(jittercheckx2); eliminateNaNs(jitterchecky2);
    eliminateNaNs(jittercheckx3); eliminateNaNs(jitterchecky3);

#if APPLY_BUG_FIXES
    ArrayXd errorVec = 1.0/6.0*(abs(xinterp1 - (jittercheckx1 + X1(0).real()/2.0)) +
                                abs(xinterp2 - (jittercheckx2 + X2(0).real()/2.0)) +
                                abs(xinterp3 - (jittercheckx3 + X3(0).real()/2.0)) +
                                abs(yinterp1 - (jitterchecky1 + Y1(0).real()/2.0)) +
                                abs(yinterp2 - (jitterchecky2 + Y2(0).real()/2.0)) +
                                abs(yinterp3 - (jitterchecky3 + Y3(0).real()/2.0)));
#else
    ArrayXd errorVec = 1.0/6.0*(abs(xinterp1 - (jittercheckx1 + X1(0).real() / 2)) +
                                abs(xinterp2 - (jittercheckx2 + X2(0).real()))     +
                                abs(xinterp3 - (jittercheckx3 + X3(0).real()))     +
                                abs(yinterp1 - (jitterchecky1 + Y1(0).real() / 2)) +
                                abs(yinterp2 - (jitterchecky2 + Y2(0).real() / 2)) +
                                abs(yinterp3 - (jitterchecky3 + Y3(0).real() / 2)));
#endif
    
    error = errorVec.mean();
    cout << "error 2: " << error << endl;
    
    if (error < minAvgError){
      minK             = k;
      minAvgError      = error;
      Sample           = jitterxx;
      Line             = jitteryy;
      minJitterCheckX1 = jittercheckx1;
      minJitterCheckX2 = jittercheckx2;
      minJitterCheckX3 = jittercheckx3;
      minJitterCheckY1 = jitterchecky1;
      minJitterCheckY2 = jitterchecky2;
      minJitterCheckY3 = jitterchecky3;
    }
    
  }

  // The outputs
  cout << " Average error is " << minAvgError << " at min index " << minK  << endl;
  std::cout << "linerate is " << linerate << std::endl;
  std::cout << "TDI = " << TDI << std::endl;

  double maxSmearSample, maxSmearLine, maxSmearMag;
  pixelSmear(// Inputs
             Sample, Line, ET, linerate, TDI, imageLocation, imageId,
             // Outputs 
             maxSmearSample, maxSmearLine, maxSmearMag
             );

  // To do: Remove the cpp suffix from jitter and smear!
  
  // Make a text file of the jitter data
  string jitterFileName = imageLocation + imageId + "_jitter_cpp.txt";
  std::cout << "Writing: " << jitterFileName << std::endl;
  FILE * fid = fopen (jitterFileName.c_str(), "w");  
  fprintf(fid,"# Using image %s the jitter was found with an\n",imageId.c_str());
  fprintf(fid,"# Average Error of %f\n", minAvgError);
  //fprintf(fid,"# Maximum Cross-track pixel smear %f\n", maxSmearSample);
  //fprintf(fid,"# Maximum Down-track pixel smear %f\n", maxSmearLine);
  fprintf(fid,"# Maximum Pixel Smear Magnitude %f\n", maxSmearMag);
  fprintf(fid,"#\n# Sample                 Line                   ET \n");
  for (int s = 0; s < Sample.size(); s++){
    fprintf(fid,"%12.16f     %12.16f     %12.9f\n", Sample(s), Line(s), ET(s));
  }
  fclose(fid);

  // Writing the data we will plot later in gnuplot
  
  string dataFileName = imageLocation + imageId + "_jitter_plot_cpp.txt";
  ArrayXd t1_shift = t1 - t0, t2_shift = t2 - t0, t3_shift = t3 - t0;
  ArrayXd jittercheckx1_shift = minJitterCheckX1 + X1(0).real()/2.0;
  ArrayXd jitterchecky1_shift = minJitterCheckY1 + Y1(0).real()/2.0;
  ArrayXd jittercheckx2_shift = minJitterCheckX2 + X2(0).real()/2.0;
  ArrayXd jitterchecky2_shift = minJitterCheckY2 + Y2(0).real()/2.0;
  ArrayXd jittercheckx3_shift = minJitterCheckX3 + X3(0).real()/2.0;
  ArrayXd jitterchecky3_shift = minJitterCheckY3 + Y3(0).real()/2.0;
  ArrayXd* Data[] =
    {&ET_shift, &Sample, &Line,
     &t1_shift,
     &offx1, &xinterp1, &jittercheckx1_shift,
     &offy1, &yinterp1, &jitterchecky1_shift,
     &t2_shift,
     &offx2, &xinterp2, &jittercheckx2_shift,
     &offy2, &yinterp2, &jitterchecky2_shift,
     &t3_shift,
     &offx3, &xinterp3, &jittercheckx3_shift,
     &offy3, &yinterp3, &jitterchecky3_shift
    };
  string Labels[] =
    {"# ET_shift", // Note the comment before the first label
     "Sample", "Line",
     "t1_shift",
     "offx1", "xinterp1", "jittercheckx1_shift",
     "offy1", "yinterp1", "jitterchecky1_shift",
     "t2_shift",
     "offx2", "xinterp2", "jittercheckx2_shift",
     "offy2", "yinterp2", "jitterchecky2_shift",
     "t3_shift",
     "offx3", "xinterp3", "jittercheckx3_shift",
     "offy3", "yinterp3", "jitterchecky3_shift"
    };
  
  int numData = sizeof(Data)/sizeof(ArrayXd*);
  writeDataForPlotting(dataFileName, numData, Data, Labels);

  string gnuplotFileName = imageLocation + imageId + "_jitter_plot_cpp.plt";
  string imgFileName     = imageLocation + imageId + "_jitter_plot_cpp.png";
  writeGnuplotFile(gnuplotFileName, dataFileName, imgFileName,  
                   filePath1, filePath2, filePath3);
  
  return 0;
}
