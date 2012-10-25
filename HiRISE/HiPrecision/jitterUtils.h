#ifndef JITTERUTILS_H
#define JITTERUTILS_H

#include <iostream>
#include <limits>
#include <string>
#include <vector>
#include <set>
#include <Eigen/Dense>
#include <unsupported/Eigen/FFT>
#include "jitterUtils.h"

// Utilities for resolveJitter4HIJACK and resolveJitter4LROC

// For pchip
extern "C" void dpchic_(const int * ic, const double * vc, const double * sw, const int * n,
                        const double * x, const double * y, double * d,
                        const int * incfd, const double * wk, const int * nwk, int * ierr);
extern "C" void dpchfe_(const int * n, const double * x, const double * y, const double * d,
                        const int * incfd, const int * skip,
                        int * ni, const double * xi, double * yi, int * ierr);

namespace jitter {
  
  inline long long upperPowerOfTwo(double val){
    // Find the smallest power of 2 which is >= val.
    long long result = 1;
    while (result < val) result <<= 1;
    return result;
  }


  inline bool isNaN(double x){
    return (x != x);
  }
  
  inline bool isInf(double x){
    return (x == std::numeric_limits<double>::infinity());
  }

  std::string getline(std::string filePath, std::ifstream & handle, int headerlines);

  void getlines(std::string filePath, int headerlines, std::vector< std::vector<double> > & data);
    
  Eigen::ArrayXcd fft(const Eigen::ArrayXd & x);
  
  Eigen::ArrayXcd ifft(const Eigen::ArrayXcd & xFreq);
  
  void filterData(int nfft, double c, const Eigen::ArrayXd & xin,  // inputs
                  Eigen::ArrayXd & xout                            // outputs
                  );
  
  void medfilt1d(double const * x, // Input signal 
                 double       * m, // Output signal buffer 
                 int            N, // Size of input signal 
                 int            W  // Size of sliding window
                 );
  
  Eigen::ArrayXd pchip(const Eigen::ArrayXd & x, const Eigen::ArrayXd & y,
                       const Eigen::ArrayXd & xi, double extrapval);
  
  Eigen::ArrayXd uniform_interp(const Eigen::ArrayXd & x, const Eigen::ArrayXd & y,
                                const Eigen::ArrayXd & xi, double extrapval);
  
  void createMatrices(// Inputs
                      bool isFirstTime, int nfft,
                      double t0, double duration,
                      double dt, Eigen::ArrayXd const& t,
                      Eigen::ArrayXd const& offx, Eigen::ArrayXd const& offy,
                      // Outputs
                      Eigen::ArrayXd & tt, Eigen::ArrayXd & ET, Eigen::ArrayXd & ET_shift,
                      Eigen::ArrayXd & ddt,
                      Eigen::ArrayXd & xinterp, Eigen::ArrayXd & yinterp,
                      Eigen::ArrayXcd & X, Eigen::ArrayXcd & Y,
                      Eigen::MatrixXd & overxx, Eigen::MatrixXd & overyy
                      );
  
  void makeNullProblematicFrequencies(// Inputs
                                      double phasetol, Eigen::ArrayXd const& ddt,
                                      // Outputs
                                      std::set<int> & nullindex,
                                      Eigen::MatrixXd & overxxx,
                                      Eigen::MatrixXd & overyyy                                    
                                      );
  
  void makeNullIfNaNinFirstColumn(Eigen::MatrixXd & M);

  void sumOverEachRow(Eigen::MatrixXd const& M, Eigen::ArrayXd & sumM);

  void eliminateNaNs(Eigen::ArrayXd & M);
}

#endif
