// Utilities for resolveJitter4HIJACK and resolveJitter4LROC

#include <algorithm>
#include <cmath>
#include <ctime>
#include <fstream>
#include <iostream>
#include <set>
#include <sstream>
#include <string>
#include <vector>
#include <Eigen/Dense>
#include <unsupported/Eigen/FFT>
#include "jitterUtils.h"

using namespace std;
using namespace Eigen;
using namespace jitter;

string jitter::getline(string filePath, ifstream & handle, int headerlines){
  
  // From the current position in the stream, skip the given amount of
  // lines (the value of headerlines) and return the next line as a
  // string.

  if (!handle.is_open()){
    std::cerr << "ERROR: Cannot open file: " << filePath << std::endl;
    exit(1);
  }

  string line;
  int count = 0;
  while ( handle.good() ){
    getline(handle, line);
    count++;
    if (count > headerlines){
      return line;
      break;
    }
  }

  // Must never come here
  cerr << "ERROR: Not enough data in file: " << filePath << endl;
  exit(1);
  
  return "";
}

void jitter::getlines(string filePath, int headerlines, vector< vector<double> > & data){
  
  // From the current position in the stream, skip the given amount of
  // lines (the value of headerlines) and return the values on the
  // remaining lines in a matrix of double values.

  // First thing reset the output
  data.clear();
  
  ifstream handle(filePath.c_str());
  if (!handle){
    std::cerr << "ERROR: Cannot open file: " << filePath << std::endl;
    exit(1);
  }

  // Skip headerlines
  string line;
  int count = 0;
  while ( handle.good() ){
    getline(handle, line);
    count++;
    if (count >= headerlines){
      break;
    }
  }

  if (count < headerlines){
    cerr << "ERROR: Not enough data in file: " << filePath << endl;
    exit(1);
  }
  
  // Read the data
  vector<double> lineVec;
  while ( handle.good() ){

    getline(handle, line);

    replace(line.begin(), line.end(), ',', ' ');
      
    // Put the numbers on the current line into a vector
    istringstream iss(line);
    
    lineVec.clear();
    double val;
    while ( iss >> val ) lineVec.push_back(val);
    
    if (lineVec.size() > 0) data.push_back(lineVec);
  }

  return;
}

ArrayXcd jitter::fft(const ArrayXd & x){

  // Forward Fast Fourier transform wrapper.

  FFT<double> fft;

  vector<double> xVec;
  xVec.assign(&x(0), &x(0) + x.size()); 

  vector< complex<double> > xFreqVec;
  fft.fwd(xFreqVec, xVec);
  ArrayXcd xFreq;
  if (!xFreqVec.empty())
    xFreq = Map<ArrayXcd>(&xFreqVec[0], xFreqVec.size(), 1);
  
  return xFreq;
}

ArrayXcd jitter::ifft(const ArrayXcd & xFreq){

  // Inverse Fast Fourier transform wrapper.
  
  FFT<double> fft;

  vector< complex<double> > xFreqVec;
  xFreqVec.assign(&xFreq(0), &xFreq(0) + xFreq.size()); 

  vector< complex<double> > xVec;
  fft.inv(xVec, xFreqVec);  

  ArrayXcd x;
  if (!xVec.empty())
    x = Map<ArrayXcd>(&xVec[0], xVec.size(), 1);

  return x;
}

void jitter::filterData(int nfft, double c, const ArrayXd & xin,  // inputs
                        ArrayXd & xout                            // outputs
                        ){
  
  // Apply a Gaussian filter to the data in the frequency domain.
  // This is an implementation of the Matlab bloc:
  
  // xout=ifft(fft([ones(1,frontPadding)*xin(1), xin, ones(1,backPadding)*xin(a)],nfft*2).*exp(-(c*[0:(nfft-1) -(nfft):-1]).^2),nfft*2,'symmetric');
  //xout=xout((frontPadding+1):(frontPadding+a));

  // Use padding so the data is not distorted.

  int numRows = xin.size();
  
  int frontPadding = (int)floor((nfft-numRows/2.0));
  int backPadding  = (int)ceil ((nfft-numRows/2.0));
  int totalN       = frontPadding + numRows + backPadding;
  if (totalN != 2*nfft){
    cerr << "ERROR: An assumption about vector size has been violated." << endl;
    exit(1);
  }

  // Apply the padding
  ArrayXd paddedX(totalN, 1);
  paddedX <<
    ArrayXd::Constant(frontPadding, 1, xin(0)),
    xin,
    ArrayXd::Constant(backPadding, 1, xin(numRows - 1));

  ArrayXcd xFreq = fft(paddedX);

  // The exponential
  ArrayXd expVec(totalN, 1);
  expVec << ArrayXd::LinSpaced(nfft, 0, nfft-1), ArrayXd::LinSpaced(nfft, -nfft, -1);
  expVec = exp( -( c*expVec ) * ( c*expVec ) );
  
  // The ifft of the product
  ArrayXcd filteredX = ifft(xFreq * expVec);
  
  // Remove the padding and take the real part
  xout = filteredX.block(frontPadding, 0, numRows, 1).real();

  return;
}

void jitter::medfilt1d(double const * x, // Input signal 
                       double       * m, // Output signal buffer 
                       int            N, // Size of input signal 
                       int            W  // Size of sliding window
                       ){
  
  // Perform running median filtering. There exist faster implementations.
  
  int i, k, idx;
  int W2 = W/2, Wm2 = (W-1)/2;
        
  vector<double> w(W), xic(W), xfc(W);
    
  for (i = 0; i < N; i ++){
      
    // Fill up the sliding window
    for (k = 0; k < W; k++){
        
      idx = i - W2 + k;
        
      if (idx < 0){
        // Need to get values from the initial condition vector
        w[k] = xic[W2 + idx];
      }else if (idx >= N){
        // Need to get values from the final condition vector
        w[k] = xfc[idx - N];
      }else{
        w[k] = x[idx];
      }
    }
      
    // The median
    sort(w.begin(), w.end());
    m[i] = ( w[Wm2] + w[W2] )/2.0;
  }

  return;
}

ArrayXd jitter::pchip(const ArrayXd & x, const ArrayXd & y, const ArrayXd & xi, double extrapval){
  
  // Call a Fortran 77 code to do pchip interpolation.
  
  // The analog of the Matlab function:
  // yi = interp1(x, y, xi, 'pchip', extrapval);
  // 'pchip' means Piecewise Cubic Hermite Interpolating Polynomial.

  // The value extrapval replaces the values outside of the interval
  // spanned by X.
  
  int n  = x.size();
  int ni = xi.size();

  // Flags which determine how to interpolate beyond the interval
  int ic[2]; ic[0] = 0; ic[1] = 0;
  double vc[2];
  double sw = 0.0;

  int nwk = 2*(n-1), incfd = 1, ierr;
  ArrayXd yi(ni, 1), d(n, 1), wk(nwk, 1);

  dpchic_(ic, vc, &sw, &n, &x(0), &y(0), &d(0), &incfd, &wk(0), &nwk, &ierr);

  int skip = 1;
  dpchfe_(&n, &x(0), &y(0), &d(0), &incfd, &skip, &ni, &xi(0), &yi(0), &ierr);

  for (int s = 0; s < ni; s++){
    if (xi(s) < x(0) || xi(s) > x(n - 1) ){
      yi(s) = extrapval;
    }
  }
  
  return yi;
}

ArrayXd jitter::uniform_interp(const ArrayXd & x, const ArrayXd & y, const ArrayXd & xi, double extrapval){

  // Linear interpolation.
  // We assume here that x is increasing and uniformly spaced.

  // The value extrapval replaces the values outside of the interval
  // spanned by X.
  
  int n  = x.size();
  int ni = xi.size();

  if (n <= 1){
    cerr << "ERROR: Expecting at least two points in the input vector in interpolation." << endl;
    exit(1);
  }
  
  ArrayXd yi(xi.rows(), xi.cols());

  double dx = x(1) - x(0);
  if (dx <= 0.0){
    cerr << "ERROR: Expecting an increasing vector in interpolation." << endl;
    exit(1);
  }
  
  for (int s = 0; s < ni; s++){
    
    if ( xi(s) < x(0) || xi(s) > x(n - 1) ){
      yi(s) = extrapval;
    }else{

      int j  = (int)floor((xi(s) - x(0))/dx); if (j  <  0) j  = 0;
      int jn = j + 1;                         if (jn >= n) jn = n - 1;
      
      double slope = (y(jn) - y(j))/(x(jn) - x(j));
      if ( x(jn) == x(j) ) slope = 0.0;
      yi(s) = slope*(xi(s) - x(j)) + y(j);
    }
  }
  
  return yi;
}
  
void jitter::createMatrices(// Inputs
                            bool isFirstTime, int nfft,
                            double t0, double duration,
                            double dt, ArrayXd const& t, ArrayXd const& offx, ArrayXd const& offy,
                            // Outputs
                            ArrayXd & tt, ArrayXd & ET, ArrayXd & ET_shift,
                            ArrayXd & ddt,
                            ArrayXd & xinterp, ArrayXd & yinterp,
                            ArrayXcd & X, ArrayXcd & Y, MatrixXd & overxx, MatrixXd & overyy
                            ){
  
  // making time regularly spaced and interpolate offx and offy into this time
  if (isFirstTime){
    tt       = ArrayXd::LinSpaced(nfft, 0, nfft-1)/(1.0*nfft);
    ET       = ArrayXd::LinSpaced(nfft, 0, nfft-1)*duration/(nfft - 1.0) + t0;
    ET_shift = ET - t0;
  }
  ArrayXd t_shift = t - t0;
  xinterp = pchip(t_shift, offx, ET_shift, offx.mean());
  yinterp = pchip(t_shift, offy, ET_shift, offy.mean());

  // getting the frequencies of the Fourier transform
  ArrayXd freq  = ArrayXd::LinSpaced(nfft/2, 0, nfft/2-1);
  
  //taking the fourier transform of the offsets
  X = 2*fft(xinterp)/nfft;
  Y = 2*fft(yinterp)/nfft;

  //seperating sines and cosines
  ArrayXd XA = X.block(0, 0, nfft/2, 1).real();
  ArrayXd XB = -X.block(0, 0, nfft/2, 1).imag();
  ArrayXd YA = Y.block(0, 0, nfft/2, 1).real();
  ArrayXd YB = -Y.block(0, 0, nfft/2, 1).imag();

  //calculates the phase difference
  //ddt=mod(dt/duration*2*pi.*freq,2*pi);
  double pi = M_PI, twopi = 2*pi;
  ddt = (dt/duration*twopi)*freq;
  for (int s = 0; s < ddt.size(); s++){
    ddt(s) -= twopi*floor(ddt(s)/twopi);
  }

  //the coeficients for the frequencies
  ArrayXd aaax = -0.5*(-XA*cos(ddt)+sin(ddt)*XB-XA)/sin(ddt);
  ArrayXd aaay = -0.5*(-YA*cos(ddt)+sin(ddt)*YB-YA)/sin(ddt);
  ArrayXd bbbx = -0.5*( XB*cos(ddt)+sin(ddt)*XA+XB)/sin(ddt);
  ArrayXd bbby = -0.5*( YB*cos(ddt)+sin(ddt)*YA+YB)/sin(ddt);

  //create series of sines and cosines
  //timesfreq=2*pi*freq'*tt;
  //overxx=aaax*sin(timesfreq)+bbbx*cos(timesfreq);
  //overyy=aaay*sin(timesfreq)+bbby*cos(timesfreq);
  ArrayXd freq2 = twopi*freq;
  int nr = freq2.size(), nc = tt.size();
  overxx.resize(nr, nc);
  overyy.resize(nr, nc);
  for (int col = 0; col < nc; col++){
    for (int row = 0; row < nr; row++){
      double ft = freq2(row)*tt(col);
      double sn = sin(ft);
      double cn = cos(ft);
      overxx(row, col) = aaax(row)*sn + bbbx(row)*cn;
      overyy(row, col) = aaay(row)*sn + bbby(row)*cn;
    }
  }

  return;
}

void jitter::makeNullProblematicFrequencies(// Inputs
                                            double phasetol, ArrayXd const& ddt,
                                            // Outputs
                                            set<int> & nullindex,
                                            MatrixXd & overxxx,
                                            MatrixXd & overyyy                                    
                                            ){
  
  //null the frequencies that cause a problem

  //nullindex=abs(ddt)<phasetol | (2*pi-abs(ddt))< phasetol;
  double twopi = 2*M_PI;
  nullindex.clear();
  for (int s = 0; s < ddt.size(); s++){
    bool isSmall = ( abs(ddt(s))<phasetol || (twopi-abs(ddt(s)))< phasetol );
    if (isSmall) nullindex.insert(s);
  }

  //overxxx(nullindex,:)=0; overyyy(nullindex,:)=0;
  for (int col = 0; col < overxxx.cols(); col++){
    for (set<int>::iterator it = nullindex.begin(); it != nullindex.end(); it++){
      overxxx(*it, col) = 0;
      overyyy(*it, col) = 0;
    }
  }

  return;
}

void jitter::makeNullIfNaNinFirstColumn(MatrixXd & M){

  // M(isnan(M(:,1)),:)=0;
  for (int row = 0; row < M.rows(); row++){
    if (isNaN(M(row, 0))){
      for (int col = 0; col < M.cols(); col++){
        M(row, col) = 0;
      }
    }
  }

   return;
}

void jitter::sumOverEachRow(MatrixXd const& M,
                            ArrayXd       & sumM
                            ){

  // take the sum of each row
  //sumM = sum(M,1);
  sumM = ArrayXd::Zero(M.cols(), 1);
  for (int col = 0; col < M.cols(); col++){
    for (int row = 0; row < M.rows(); row++){
      sumM(col) += M(row, col);
    }
  }

  return;
}

void jitter::eliminateNaNs(ArrayXd & M){
  // Set all NaN values to 0 in the given matrix.
  for (int s = 0; s < M.size(); s++) if (isNaN(M(s))) M(s) = 0;
}

