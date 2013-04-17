#include <boost/thread.hpp>
#include <iostream>
extern "C"{
  void dlartg_(double* f, double* g, double* cs, double* sn, double* r);
}

void thread(){

  double s = 0;
  for (int k = 0; k < 1000; k++){

    double f= 3.9721389475513633-0.1*k, g=k*0.0026222593351486502,
      cs=0.99989379428706004-0.9*k, sn=-0.014573954378503997/k,
      r= -0.043088096521494715 + k;

    dlartg_(&f, &g, &cs, &sn, &r);
    s -= (r/0.4 + f*g - g-cs+sn);
  }

  std::cout << "Thread " << boost::this_thread::get_id() << ": " << s << std::endl;
}

int main()
{
  boost::thread t1(thread);
  boost::thread t2(thread);
  t1.join();
  t2.join();
  return 0;

}
